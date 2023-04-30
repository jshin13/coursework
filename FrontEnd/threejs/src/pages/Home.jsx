import React from 'react'
// 'rafce' from ES7+

import { motion, AnimatePresence } from 'framer-motion';
import { useSnapshot } from 'valtio';

import {
  headContainerAnimation,
  headContentAnimation,
  headTextAnimation,
  slideAnimation
} from '../config/motion';

import state from '../store';

const Home = () => {
  const snap = useSnapshot(state);

  return (
    <AnimatePresence>
      {snap.intro && (
        <motion.section className='home' {...slideAnimation('left')}>
          <motion.header {...slideAnimation('up')}>
            <div class='text-xs'>
              Header 1 - Start
              <img 
                src='./vite.svg'
                alt='logo'
                className='w-8 h-8 object-contain'
              />
              Header 1 - End
            </div>
          </motion.header>

        <br />

          <motion.header {...slideAnimation('down')}>
            <div class='text-xs'>
              Header 2 - Start
              <img 
                src='./vite.svg'
                alt='logo'
                className='w-8 h-8 object-contain'
              />
              Header 2 - End
            </div>
          </motion.header>



          <br />

        </motion.section>
      )}
    </AnimatePresence>
  )
}

export default Home
