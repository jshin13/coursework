import { proxy } from 'valtio';

const state = proxy({
    intro: true,
    color: '#FFF',
    isLogoTexture: true,
    isFullTexture: false,
    locoDecal: './vite.png',
    fullDecal: './vite.png' //from public folder
});

export default state;