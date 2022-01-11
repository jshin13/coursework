from util import util
import numpy as np
import random
import matplotlib.pyplot as plt
from matplotlib.path import Path
from scipy.spatial import Voronoi, voronoi_plot_2d


def generate_polytope(rng, h, grid, label=None, seed=1234, no_plot=False):

    fig, ax = plt.subplots(1,2, figsize=(6*2,6))

    polylist = [4, 64]

    regions = [[] for _ in range(len(polylist))]
    vertices = [[] for _ in range(len(polylist))]
    polytope_points = [[] for _ in range(len(polylist))]

    for ix, k in enumerate(polylist):

        if label is not None:
            grid = util.generate_mask(rng=rng, h=h)
            grid = np.append(grid, label.reshape(-1,1), axis=1)

        random.seed(seed)

        choice = random.choices(grid, k=k)
        choice = np.array(choice)

        vr = Voronoi(choice[:,:2])

        regions[ix], vertices[ix] = voronoi_finite_polygons_2d(vr)

        for region in regions[ix]:
            poly = [vertices[ix][i] for i in region]
            p = Path(poly)
            polytope_points[ix].append(grid[p.contains_points(grid[:,:2])])

        # if no_plot:
        #     ax[ix].scatter(polytope_points[ix][:,0],polytope_points[ix][:,1],c=polytope_points[ix][:,2], cmap='PRGn', vmin=0, vmax=1)
            # voronoi_plot_2d(vr, ax=ax[ix])

            # ax[ix].set_xlim(-1,1)
            # ax[ix].set_ylim(-1,1)
            # continue

        for coor in polytope_points[ix]:
            if no_plot:
                ax[ix].scatter(coor[:,0],coor[:,1],c=coor[:,2], cmap='PRGn', vmin=0, vmax=1)
                # for cor in coor:
                #     ax[ix].scatter(cor[0], cor[1], c=cor[2], cmap='PRGn', vmin=0, vmax=1)
            elif coor.shape[1] > 2:
                coor[:,2] = coor[:,2].mean()
                ax[ix].scatter(coor[:,0],coor[:,1],c=coor[:,2], cmap='PRGn', vmin=0, vmax=1)
            else:
                ax[ix].scatter(coor[:,0],coor[:,1], cmap='PRGn', vmin=0, vmax=1)

        voronoi_plot_2d(vr, ax=ax[ix])

        ax[ix].set_xlim(-2,2)
        ax[ix].set_ylim(-2,2)

    return polytope_points

def calculate_risks(pA, pB, N):

    polylist = [4,64]
    risks = [[] for _ in range(len(polylist))]

    for ix, k in enumerate(polylist):

        risk = 0

        for pp, pp_test in zip(pA[ix], pB[ix]):
            for ppt in pp_test:
                risk += np.argmax([0.5, pp[0][2]]) - int(ppt[2])

        risk /= N

        risks[ix] = risk

    return risks

def voronoi_finite_polygons_2d(vor, radius=None):
    # adopted from https://stackoverflow.com/questions/20515554/colorize-voronoi-diagram

    """
    Reconstruct infinite voronoi regions in a 2D diagram to finite
    regions.

    Parameters
    ----------
    vor : Voronoi
        Input diagram
    radius : float, optional
        Distance to 'points at infinity'.

    Returns
    -------
    regions : list of tuples
        Indices of vertices in each revised Voronoi regions.
    vertices : list of tuples
        Coordinates for revised Voronoi vertices. Same as coordinates
        of input vertices, with 'points at infinity' appended to the
        end.

    """

    if vor.points.shape[1] != 2:
        raise ValueError("Requires 2D input")

    new_regions = []
    new_vertices = vor.vertices.tolist()

    center = vor.points.mean(axis=0)
    if radius is None:
        radius = vor.points.ptp().max()

    # Construct a map containing all ridges for a given point
    all_ridges = {}
    for (p1, p2), (v1, v2) in zip(vor.ridge_points, vor.ridge_vertices):
        all_ridges.setdefault(p1, []).append((p2, v1, v2))
        all_ridges.setdefault(p2, []).append((p1, v1, v2))

    # Reconstruct infinite regions
    for p1, region in enumerate(vor.point_region):
        vertices = vor.regions[region]

        if all(v >= 0 for v in vertices):
            # finite region
            new_regions.append(vertices)
            continue

        # reconstruct a non-finite region
        ridges = all_ridges[p1]
        new_region = [v for v in vertices if v >= 0]

        for p2, v1, v2 in ridges:
            if v2 < 0:
                v1, v2 = v2, v1
            if v1 >= 0:
                # finite ridge: already in the region
                continue

            # Compute the missing endpoint of an infinite ridge

            t = vor.points[p2] - vor.points[p1] # tangent
            t /= np.linalg.norm(t)
            n = np.array([-t[1], t[0]])  # normal

            midpoint = vor.points[[p1, p2]].mean(axis=0)
            direction = np.sign(np.dot(midpoint - center, n)) * n
            far_point = vor.vertices[v2] + direction * radius

            new_region.append(len(new_vertices))
            new_vertices.append(far_point.tolist())

        # sort region counterclockwise
        vs = np.asarray([new_vertices[v] for v in new_region])
        c = vs.mean(axis=0)
        angles = np.arctan2(vs[:,1] - c[1], vs[:,0] - c[0])
        new_region = np.array(new_region)[np.argsort(angles)]

        # finish
        new_regions.append(new_region.tolist())

    return new_regions, np.asarray(new_vertices)