import { useState, useEffect } from 'react'
import { Plus, Upload, Search, Edit, Trash2, X } from 'lucide-react'
import { apiClient, InventoryItem, MenuItem } from '../lib/api'

export default function Inventory() {
  const [items, setItems] = useState<InventoryItem[]>([])
  const [menuItems, setMenuItems] = useState<MenuItem[]>([])
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState<'all' | 'ok' | 'low' | '86'>('all')
  const [loading, setLoading] = useState(true)
  const [showAddForm, setShowAddForm] = useState(false)
  const [editingItem, setEditingItem] = useState<InventoryItem | null>(null)
  const [formData, setFormData] = useState({
    item_id: '',
    status: 'ok' as 'ok' | 'low' | '86',
    notes: '',
    expected_back: ''
  })

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      setLoading(true)
      const [inventoryData, menuData] = await Promise.all([
        apiClient.getInventory(),
        apiClient.getMenuItems()
      ])
      setItems(inventoryData)
      setMenuItems(menuData)
    } catch (error) {
      console.error('Failed to fetch inventory data:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredItems = items.filter(item => {
    const itemName = item.menu_item?.name || 'Unknown Item'
    const matchesSearch = itemName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         item.item_id.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesStatus = statusFilter === 'all' || item.status === statusFilter
    return matchesSearch && matchesStatus
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      if (editingItem) {
        // Update existing item
        await apiClient.updateInventoryItem(editingItem.id, formData)
      } else {
        // Create new item
        await apiClient.createInventoryItem(formData)
      }
      
      // Reset form and refresh data
      setFormData({ item_id: '', status: 'ok', notes: '', expected_back: '' })
      setShowAddForm(false)
      setEditingItem(null)
      await fetchData()
    } catch (error) {
      console.error('Failed to save inventory item:', error)
    }
  }

  const handleEdit = (item: InventoryItem) => {
    setEditingItem(item)
    setFormData({
      item_id: item.item_id,
      status: item.status,
      notes: item.notes || '',
      expected_back: item.expected_back || ''
    })
    setShowAddForm(true)
  }

  const handleDelete = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this inventory item?')) {
      try {
        await apiClient.deleteInventoryItem(id)
        await fetchData()
      } catch (error) {
        console.error('Failed to delete inventory item:', error)
      }
    }
  }

  const handleCSVUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    try {
      await apiClient.uploadInventoryCSV(file)
      await fetchData()
      alert('CSV uploaded successfully!')
    } catch (error) {
      console.error('Failed to upload CSV:', error)
      alert('Failed to upload CSV. Please check the format.')
    }
  }

  const getStatusBadge = (status: string) => {
    const baseClasses = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    switch (status) {
      case 'ok':
        return `${baseClasses} bg-success-100 text-success-800`
      case 'low':
        return `${baseClasses} bg-warning-100 text-warning-800`
      case '86':
        return `${baseClasses} bg-danger-100 text-danger-800`
      default:
        return `${baseClasses} bg-gray-100 text-gray-800`
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Inventory Management</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage your 86 board and stock levels
          </p>
        </div>
        <div className="flex space-x-3">
          <label className="btn btn-secondary flex items-center cursor-pointer">
            <Upload className="h-4 w-4 mr-2" />
            Upload CSV
            <input
              type="file"
              accept=".csv"
              onChange={handleCSVUpload}
              className="hidden"
            />
          </label>
          <button 
            onClick={() => setShowAddForm(true)}
            className="btn btn-primary flex items-center"
          >
            <Plus className="h-4 w-4 mr-2" />
            Add Item
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex-1">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <input
                type="text"
                placeholder="Search items..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="input pl-10"
              />
            </div>
          </div>
          <div className="flex space-x-2">
            <button
              onClick={() => setStatusFilter('all')}
              className={`btn ${statusFilter === 'all' ? 'btn-primary' : 'btn-secondary'}`}
            >
              All
            </button>
            <button
              onClick={() => setStatusFilter('ok')}
              className={`btn ${statusFilter === 'ok' ? 'btn-primary' : 'btn-secondary'}`}
            >
              OK
            </button>
            <button
              onClick={() => setStatusFilter('low')}
              className={`btn ${statusFilter === 'low' ? 'btn-primary' : 'btn-secondary'}`}
            >
              Low Stock
            </button>
            <button
              onClick={() => setStatusFilter('86')}
              className={`btn ${statusFilter === '86' ? 'btn-primary' : 'btn-secondary'}`}
            >
              86'd
            </button>
          </div>
        </div>
      </div>

      {/* Add/Edit Form */}
      {showAddForm && (
        <div className="card">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-medium text-gray-900">
              {editingItem ? 'Edit Inventory Item' : 'Add New Inventory Item'}
            </h3>
            <button
              onClick={() => {
                setShowAddForm(false)
                setEditingItem(null)
                setFormData({ item_id: '', status: 'ok', notes: '', expected_back: '' })
              }}
              className="text-gray-400 hover:text-gray-600"
            >
              <X className="h-5 w-5" />
            </button>
          </div>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Menu Item
                </label>
                <select
                  value={formData.item_id}
                  onChange={(e) => setFormData({ ...formData, item_id: e.target.value })}
                  className="input"
                  required
                >
                  <option value="">Select a menu item</option>
                  {menuItems.map((menuItem) => (
                    <option key={menuItem.item_id} value={menuItem.item_id}>
                      {menuItem.name} ({menuItem.item_id})
                    </option>
                  ))}
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Status
                </label>
                <select
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value as 'ok' | 'low' | '86' })}
                  className="input"
                  required
                >
                  <option value="ok">OK</option>
                  <option value="low">Low Stock</option>
                  <option value="86">86'd</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Notes
                </label>
                <input
                  type="text"
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  className="input"
                  placeholder="Optional notes..."
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Expected Back
                </label>
                <input
                  type="date"
                  value={formData.expected_back}
                  onChange={(e) => setFormData({ ...formData, expected_back: e.target.value })}
                  className="input"
                />
              </div>
            </div>
            
            <div className="flex justify-end space-x-3">
              <button
                type="button"
                onClick={() => {
                  setShowAddForm(false)
                  setEditingItem(null)
                  setFormData({ item_id: '', status: 'ok', notes: '', expected_back: '' })
                }}
                className="btn btn-secondary"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="btn btn-primary"
              >
                {editingItem ? 'Update Item' : 'Add Item'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Inventory Table */}
      <div className="card">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Item
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Notes
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Updated
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {loading ? (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center text-gray-500">
                    Loading inventory items...
                  </td>
                </tr>
              ) : filteredItems.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center text-gray-500">
                    {items.length === 0 
                      ? 'No inventory items found. Click "Add Item" to get started.'
                      : 'No items match your current filters.'
                    }
                  </td>
                </tr>
              ) : (
                filteredItems.map((item) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm font-medium text-gray-900">{item.menu_item?.name || 'Unknown Item'}</div>
                        <div className="text-sm text-gray-500">{item.item_id}</div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={getStatusBadge(item.status)}>
                        {item.status.toUpperCase()}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {item.notes || '-'}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(item.updated_at).toLocaleString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button 
                        onClick={() => handleEdit(item)}
                        className="text-primary-600 hover:text-primary-900 mr-3"
                      >
                        Edit
                      </button>
                      <button 
                        onClick={() => handleDelete(item.id)}
                        className="text-danger-600 hover:text-danger-900"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
