import { useState, useEffect } from 'react'
import { Database, Trash2, Download, Upload } from 'lucide-react'

interface AdminStats {
  menu_count: number
  inventory_count: number
  reviews_count: number
  changes_count: number
}

export default function Admin() {
  const [isLoading, setIsLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [stats, setStats] = useState<AdminStats>({
    menu_count: 0,
    inventory_count: 0,
    reviews_count: 0,
    changes_count: 0
  })

  const fetchStats = async () => {
    try {
      const response = await fetch('/api/v1/admin/stats')
      if (response.ok) {
        const data = await response.json()
        setStats(data)
      }
    } catch (error) {
      console.error('Failed to fetch stats:', error)
    }
  }

  useEffect(() => {
    fetchStats()
  }, [])

  const handleInjectData = async () => {
    setIsLoading(true)
    setMessage('')
    
    try {
      const response = await fetch('/api/v1/admin/inject-data', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      })
      
      if (response.ok) {
        const result = await response.json()
        setMessage(`✅ Data injected successfully! Added ${result.menu_count} menu items, ${result.inventory_count} inventory items, ${result.reviews_count} reviews, and ${result.changes_count} changes.`)
        await fetchStats() // Refresh stats after injection
      } else {
        const error = await response.json()
        setMessage(`❌ Error: ${error.detail}`)
      }
    } catch (error) {
      setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`)
    } finally {
      setIsLoading(false)
    }
  }

  const handleClearData = async () => {
    if (!confirm('Are you sure you want to clear all data? This action cannot be undone.')) {
      return
    }
    
    setIsLoading(true)
    setMessage('')
    
    try {
      const response = await fetch('/api/v1/admin/clear-data', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      })
      
      if (response.ok) {
        const result = await response.json()
        setMessage(`✅ Data cleared successfully! Removed all ${result.total_deleted} records.`)
        await fetchStats() // Refresh stats after clearing
      } else {
        const error = await response.json()
        setMessage(`❌ Error: ${error.detail}`)
      }
    } catch (error) {
      setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`)
    } finally {
      setIsLoading(false)
    }
  }

  const handleDownloadData = async () => {
    setIsLoading(true)
    setMessage('')
    
    try {
      const response = await fetch('/api/v1/admin/export-data')
      
      if (response.ok) {
        const blob = await response.blob()
        const url = window.URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = `restaurant-data-${new Date().toISOString().split('T')[0]}.json`
        document.body.appendChild(a)
        a.click()
        window.URL.revokeObjectURL(url)
        document.body.removeChild(a)
        setMessage('✅ Data exported successfully!')
      } else {
        const error = await response.json()
        setMessage(`❌ Error: ${error.detail}`)
      }
    } catch (error) {
      setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="p-6">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Admin Panel</h1>
        <p className="text-gray-600">Manage test data for the Restaurant Ops Hub</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        {/* Inject Data Card */}
        <div className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
          <div className="flex items-center mb-4">
            <Database className="h-8 w-8 text-blue-600 mr-3" />
            <h2 className="text-xl font-semibold text-gray-900">Inject Test Data</h2>
          </div>
          <p className="text-gray-600 mb-4">
            Add comprehensive test data including menu items, inventory, reviews, and changes.
          </p>
          <button
            onClick={handleInjectData}
            disabled={isLoading}
            className="w-full bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
          >
            <Upload className="h-4 w-4 mr-2" />
            {isLoading ? 'Injecting...' : 'Inject Data'}
          </button>
        </div>

        {/* Clear Data Card */}
        <div className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
          <div className="flex items-center mb-4">
            <Trash2 className="h-8 w-8 text-red-600 mr-3" />
            <h2 className="text-xl font-semibold text-gray-900">Clear All Data</h2>
          </div>
          <p className="text-gray-600 mb-4">
            Remove all data from the database. This action cannot be undone.
          </p>
          <button
            onClick={handleClearData}
            disabled={isLoading}
            className="w-full bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
          >
            <Trash2 className="h-4 w-4 mr-2" />
            {isLoading ? 'Clearing...' : 'Clear Data'}
          </button>
        </div>

        {/* Export Data Card */}
        <div className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
          <div className="flex items-center mb-4">
            <Download className="h-8 w-8 text-green-600 mr-3" />
            <h2 className="text-xl font-semibold text-gray-900">Export Data</h2>
          </div>
          <p className="text-gray-600 mb-4">
            Download all current data as a JSON file for backup or analysis.
          </p>
          <button
            onClick={handleDownloadData}
            disabled={isLoading}
            className="w-full bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
          >
            <Download className="h-4 w-4 mr-2" />
            {isLoading ? 'Exporting...' : 'Export Data'}
          </button>
        </div>
      </div>

      {/* Status Message */}
      {message && (
        <div className={`p-4 rounded-lg ${
          message.startsWith('✅') 
            ? 'bg-green-50 border border-green-200 text-green-800' 
            : 'bg-red-50 border border-red-200 text-red-800'
        }`}>
          <p className="font-medium">{message}</p>
        </div>
      )}

      {/* Data Statistics */}
      <div className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Current Data Statistics</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="text-center">
            <div className="text-2xl font-bold text-blue-600">{stats.menu_count}</div>
            <div className="text-sm text-gray-600">Menu Items</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-orange-600">{stats.inventory_count}</div>
            <div className="text-sm text-gray-600">Inventory Items</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-purple-600">{stats.reviews_count}</div>
            <div className="text-sm text-gray-600">Reviews</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-green-600">{stats.changes_count}</div>
            <div className="text-sm text-gray-600">Changes</div>
          </div>
        </div>
      </div>
    </div>
  )
}
