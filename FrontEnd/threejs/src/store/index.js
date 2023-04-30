import { proxy } from 'valtio';

const state = proxy({
    intro: true,
    color: '#FFF',
    isLogoTexture: true,
    isFullTexture: false,
    locoDecal: './vite.svg',
    fullDecal: './vite.svg' //from public folder
});

export default state;