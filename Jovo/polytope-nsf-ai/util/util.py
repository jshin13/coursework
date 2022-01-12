import numpy as np
from sklearn.datasets import make_blobs
from numpy.random import uniform, normal, shuffle
from scipy.stats import matrix_normal

def generate_gaussian_parity(
    n_samples,
    centers=None,
    class_label=None,
    cluster_std=0.25,
    center_box=(-1.0, 1.0),
    angle_params=None,
    random_state=None,
):
    """
    Generate 2-dimensional Gaussian XOR distribution.
    (Classic XOR problem but each point is the
    center of a Gaussian blob distribution)
    Parameters
    ----------
    n_samples : int
        Total number of points divided among the four
        clusters with equal probability.
    centers : array of shape [n_centers,2], optional (default=None)
        The coordinates of the ceneter of total n_centers blobs.
    class_label : array of shape [n_centers], optional (default=None)
        class label for each blob.
    cluster_std : float, optional (default=1)
        The standard deviation of the blobs.
    center_box : tuple of float (min, max), default=(-1.0, 1.0)
        The bounding box for each cluster center when centers are generated at random.
    angle_params: float, optional (default=None)
        Number of radians to rotate the distribution by.
    random_state : int, RandomState instance, default=None
        Determines random number generation for dataset creation. Pass an int
        for reproducible output across multiple function calls.
    Returns
    -------
    X : array of shape [n_samples, 2]
        The generated samples.
    y : array of shape [n_samples]
        The integer labels for cluster membership of each sample.
    """

    if random_state != None:
        np.random.seed(random_state)

    if centers == None:
        centers = np.array([(-0.5, 0.5), (0.5, 0.5), (-0.5, -0.5), (0.5, -0.5)])

    if class_label == None:
        class_label = [0, 1, 1, 0]

    blob_num = len(class_label)

    # get the number of samples in each blob with equal probability
    samples_per_blob = np.random.multinomial(
        n_samples, 1 / blob_num * np.ones(blob_num)
    )

    X, y = make_blobs(
        n_samples=samples_per_blob,
        n_features=2,
        centers=centers,
        cluster_std=cluster_std,
        center_box=center_box,
    )

    for blob in range(blob_num):
        y[np.where(y == blob)] = class_label[blob]

    if angle_params != None:
        R = _generate_2d_rotation(angle_params)
        X = X @ R

    return X, y.astype(int)

def _generate_2d_rotation(theta=0):
    R = np.array([[np.cos(theta), np.sin(theta)], [-np.sin(theta), np.cos(theta)]])

    return R

def generate_mask(rng=3, h=0.01):
    '''
    method that generates the grid in the range of [-rng, rng] at h step
    '''
    l, r = -rng, rng
    x = np.arange(l, r, h)
    y = np.arange(l, r, h)
    x, y = np.meshgrid(x, y)
    sample = np.c_[x.ravel(), y.ravel()]

    return sample

def true_xor(rng=3, h=0.01, rotate=False, sig=0.25, cc=False, **kwarg):
    '''
    method that generates true posterior for xor datasets
    '''
    # norm = kwarg['norm']
    newpdf = kwarg['newpdf']

    X = generate_mask(rng=rng, h=h)

    z = np.zeros(len(X), dtype=float)

    for ii, x in enumerate(X):
        if np.any([x <= -1.0, x >= 1.0]) and cc == False:  # or x.any() > 1
            z[ii] = 0.5
        elif np.sqrt((x**2).sum(axis=0)) > 1 and cc == True:
            z[ii] = 0.5
        else:
            if newpdf:
                x = np.array([x.tolist()])
                z[ii] = pdf(x, cov_scale=sig)
            else:
                z[ii] = alpha_pdf(x, rotate=rotate, sig=sig)

    # if norm:
    #     z = (z - min(z)) / (max(z) - min(z))
    # else:
    #     pass

    return X[:, 0], X[:, 1], z

def pdf(x, cov_scale=0.25):
    # added trace
    mu01 = np.array([[-0.5,0.5]])
    mu02 = np.array([[0.5,-0.5]])
    mu11 = np.array([[0.5,0.5]])
    mu12 = np.array([[-0.5,-0.5]])
    cov = cov_scale* np.eye(2)
    inv_cov = np.linalg.inv(cov)

    p01 = matrix_normal.pdf(x, mean=mu01, colcov=cov)
    p02 = matrix_normal.pdf(x, mean=mu02, colcov=cov)
    p11 = matrix_normal.pdf(x, mean=mu11, colcov=cov)
    p12 = matrix_normal.pdf(x, mean=mu12, colcov=cov)

    # return np.max([p01,p02])/(p01+p02+p11+p12)
    return (p01+p02)/(p01+p02+p11+p12)

def alpha_pdf(x, rotate=False, sig=0.25):
    '''
    method that draws gaussian posterior for xor true posterior
    '''
    # Generates true XOR posterior
    if rotate:
        mu01 = np.array([-0.5, 0])
        mu02 = np.array([0.5, 0])
        mu11 = np.array([0, 0.5])
        mu12 = np.array([0, -0.5])
    else:
        mu01 = np.array([-0.5, 0.5])
        mu02 = np.array([0.5, -0.5])
        mu11 = np.array([0.5, 0.5])
        mu12 = np.array([-0.5, -0.5])
    cov = sig * np.eye(2)
    inv_cov = np.linalg.inv(cov)

    p0 = (
        np.exp(-(x - mu01)@inv_cov@(x-mu01).T)
        + np.exp(-(x - mu02)@inv_cov@(x-mu02).T)
    )/(2*np.pi*np.sqrt(np.linalg.det(cov)))

    p1 = (
        np.exp(-(x - mu11)@inv_cov@(x-mu11).T)
        + np.exp(-(x - mu12)@inv_cov@(x-mu12).T)
    )/(2*np.pi*np.sqrt(np.linalg.det(cov)))

    # return p0-p1
    return p1/(p0+p1)


