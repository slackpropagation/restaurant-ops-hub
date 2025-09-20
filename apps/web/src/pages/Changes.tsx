import { useState, useEffect } from 'react'
import { Plus, Edit, Trash2, CheckCircle } from 'lucide-react'
import { apiClient, Change } from '../lib/api'

export default function Changes() {
  const [changes, setChanges] = useState<Change[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [formData, setFormData] = useState({
    title: '',
    detail: ''
  })

  useEffect(() => {
    fetchChanges()
  }, [])

  const fetchChanges = async () => {
    try {
      setLoading(true)
      const data = await apiClient.getChanges()
      setChanges(data)
    } catch (error) {
      console.error('Failed to fetch changes:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await apiClient.createChange({
        title: formData.title,
        detail: formData.detail
      })
      setFormData({ title: '', detail: '' })
      setShowForm(false)
      await fetchChanges()
    } catch (error) {
      console.error('Failed to create change:', error)
    }
  }

  const handleToggleActive = (changeId: string) => {
    setChanges(changes.map(change => 
      change.change_id === changeId 
        ? { ...change, is_active: !change.is_active }
        : change
    ))
  }

  const handleDelete = async (changeId: string) => {
    if (window.confirm('Are you sure you want to delete this change?')) {
      try {
        await apiClient.deleteChange(changeId)
        await fetchChanges()
      } catch (error) {
        console.error('Failed to delete change:', error)
      }
    }
  }

  const activeChanges = changes.filter(change => change.is_active)
  const inactiveChanges = changes.filter(change => !change.is_active)

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Changes & Announcements</h1>
          <p className="mt-1 text-sm text-gray-500">
            Share updates and announcements with your staff
          </p>
        </div>
        <button
          onClick={() => setShowForm(true)}
          className="btn btn-primary flex items-center"
        >
          <Plus className="h-4 w-4 mr-2" />
          New Change
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-3">
        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <CheckCircle className="h-8 w-8 text-primary-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Active Changes</p>
              <p className="text-2xl font-semibold text-gray-900">{activeChanges.length}</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <span className="text-2xl font-semibold text-gray-900">{changes.length}</span>
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Total Changes</p>
              <p className="text-sm text-gray-400">All time</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <span className="text-2xl font-semibold text-gray-900">
                {Math.round((activeChanges.length / changes.length) * 100)}%
              </span>
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Active Rate</p>
              <p className="text-sm text-gray-400">Currently active</p>
            </div>
          </div>
        </div>
      </div>

      {/* New Change Form */}
      {showForm && (
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Create New Change</h3>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700">
                Title
              </label>
              <input
                type="text"
                id="title"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                className="input mt-1"
                placeholder="Enter change title..."
                required
              />
            </div>
            <div>
              <label htmlFor="detail" className="block text-sm font-medium text-gray-700">
                Details
              </label>
              <textarea
                id="detail"
                value={formData.detail}
                onChange={(e) => setFormData({ ...formData, detail: e.target.value })}
                className="input mt-1"
                rows={3}
                placeholder="Enter change details..."
                required
              />
            </div>
            <div className="flex justify-end space-x-3">
              <button
                type="button"
                onClick={() => setShowForm(false)}
                className="btn btn-secondary"
              >
                Cancel
              </button>
              <button type="submit" className="btn btn-primary">
                Create Change
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Active Changes */}
      <div>
        <h2 className="text-lg font-medium text-gray-900 mb-4">Active Changes</h2>
        <div className="space-y-4">
          {activeChanges.map((change) => (
            <div key={change.change_id} className="card border-l-4 border-primary-500">
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <h3 className="text-lg font-medium text-gray-900">{change.title}</h3>
                  <p className="mt-1 text-gray-600">{change.detail}</p>
                  <div className="mt-2 flex items-center space-x-4 text-sm text-gray-500">
                    <span>By {change.created_by}</span>
                    <span>•</span>
                    <span>{new Date(change.created_at).toLocaleString()}</span>
                  </div>
                </div>
                <div className="flex items-center space-x-2">
                  <button
                    onClick={() => handleToggleActive(change.change_id)}
                    className="text-warning-600 hover:text-warning-900"
                    title="Deactivate"
                  >
                    <CheckCircle className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(change.change_id)}
                    className="text-danger-600 hover:text-danger-900"
                    title="Delete"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Inactive Changes */}
      {inactiveChanges.length > 0 && (
        <div>
          <h2 className="text-lg font-medium text-gray-900 mb-4">Inactive Changes</h2>
          <div className="space-y-4">
            {inactiveChanges.map((change) => (
              <div key={change.change_id} className="card border-l-4 border-gray-300 opacity-75">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <h3 className="text-lg font-medium text-gray-900">{change.title}</h3>
                    <p className="mt-1 text-gray-600">{change.detail}</p>
                    <div className="mt-2 flex items-center space-x-4 text-sm text-gray-500">
                      <span>By {change.created_by}</span>
                      <span>•</span>
                      <span>{new Date(change.created_at).toLocaleString()}</span>
                    </div>
                  </div>
                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => handleToggleActive(change.change_id)}
                      className="text-success-600 hover:text-success-900"
                      title="Reactivate"
                    >
                      <CheckCircle className="h-5 w-5" />
                    </button>
                    <button
                      onClick={() => handleDelete(change.change_id)}
                      className="text-danger-600 hover:text-danger-900"
                      title="Delete"
                    >
                      <Trash2 className="h-5 w-5" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {changes.length === 0 && (
        <div className="text-center py-12">
          <CheckCircle className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-medium text-gray-900">No changes yet</h3>
          <p className="mt-1 text-sm text-gray-500">
            Create your first change or announcement to get started.
          </p>
        </div>
      )}
    </div>
  )
}
