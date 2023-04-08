import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

import Canvas from './canvas';
import Customizer from './pages/Customizer';
import Home from './pages/Home';

function App() {
  const [count, setCount] = useState(0)

  return (
    <main className='app transition-allease-in'>
      <Home />
      <Canvas />
      <Customizer />
    </main>
  )
}

export default App
