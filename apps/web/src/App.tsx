import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import Dashboard from './pages/Dashboard'
import Brief from './pages/Brief'
import Inventory from './pages/Inventory'
import Reviews from './pages/Reviews'
import Changes from './pages/Changes'

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/brief" element={<Brief />} />
        <Route path="/inventory" element={<Inventory />} />
        <Route path="/reviews" element={<Reviews />} />
        <Route path="/changes" element={<Changes />} />
      </Routes>
    </Layout>
  )
}

export default App
