import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { 
  Package, 
  Star, 
  Megaphone, 
  FileText,
  AlertTriangle,
  TrendingUp,
  Clock
} from 'lucide-react'

interface DashboardStats {
  eightySixCount: number
  lowStockCount: number
  recentReviews: number
  activeChanges: number
}

export default function Dashboard() {
  const [stats, setStats] = useState<DashboardStats>({
    eightySixCount: 0,
    lowStockCount: 0,
    recentReviews: 0,
    activeChanges: 0
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // TODO: Replace with actual API calls
    // For now, simulate loading
    setTimeout(() => {
      setStats({
        eightySixCount: 3,
        lowStockCount: 7,
        recentReviews: 12,
        activeChanges: 2
      })
      setLoading(false)
    }, 1000)
  }, [])

  const quickActions = [
    {
      name: 'Generate Brief',
      href: '/brief',
      icon: FileText,
      description: 'Create today\'s pre-shift brief',
      color: 'bg-primary-500'
    },
    {
      name: 'Update Inventory',
      href: '/inventory',
      icon: Package,
      description: 'Manage 86 board and stock levels',
      color: 'bg-warning-500'
    },
    {
      name: 'View Reviews',
      href: '/reviews',
      icon: Star,
      description: 'Check recent customer feedback',
      color: 'bg-success-500'
    },
    {
      name: 'Post Changes',
      href: '/changes',
      icon: Megaphone,
      description: 'Share updates with staff',
      color: 'bg-danger-500'
    }
  ]

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">
          Welcome to Restaurant Ops Hub. Here's what's happening today.
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <AlertTriangle className="h-8 w-8 text-danger-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">86 Items</p>
              <p className="text-2xl font-semibold text-gray-900">{stats.eightySixCount}</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <TrendingUp className="h-8 w-8 text-warning-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Low Stock</p>
              <p className="text-2xl font-semibold text-gray-900">{stats.lowStockCount}</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Star className="h-8 w-8 text-success-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Recent Reviews</p>
              <p className="text-2xl font-semibold text-gray-900">{stats.recentReviews}</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Megaphone className="h-8 w-8 text-primary-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Active Changes</p>
              <p className="text-2xl font-semibold text-gray-900">{stats.activeChanges}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div>
        <h2 className="text-lg font-medium text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {quickActions.map((action) => (
            <Link
              key={action.name}
              to={action.href}
              className="group relative rounded-lg border border-gray-300 bg-white p-6 shadow-sm hover:shadow-md transition-shadow"
            >
              <div>
                <span className={`inline-flex rounded-lg p-3 ${action.color} text-white`}>
                  <action.icon className="h-6 w-6" />
                </span>
              </div>
              <div className="mt-4">
                <h3 className="text-sm font-medium text-gray-900 group-hover:text-primary-600">
                  {action.name}
                </h3>
                <p className="mt-1 text-sm text-gray-500">{action.description}</p>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Recent Activity */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Recent Reviews</h3>
          <div className="space-y-3">
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <Star className="h-5 w-5 text-yellow-400" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-900">"Great food and service!"</p>
                <p className="text-xs text-gray-500">Google • 2 hours ago</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <Star className="h-5 w-5 text-yellow-400" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-900">"Food was cold when it arrived"</p>
                <p className="text-xs text-gray-500">Google • 4 hours ago</p>
              </div>
            </div>
          </div>
        </div>

        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Recent Changes</h3>
          <div className="space-y-3">
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <Clock className="h-5 w-5 text-primary-400" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-900">New menu item added</p>
                <p className="text-xs text-gray-500">Manager • 1 hour ago</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <Clock className="h-5 w-5 text-primary-400" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-900">Kitchen hours updated</p>
                <p className="text-xs text-gray-500">Manager • 3 hours ago</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
