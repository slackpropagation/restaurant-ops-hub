// apps/web/src/lib/api.ts
import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Types
export interface InventoryItem {
  id: number
  item_id: string
  status: 'ok' | 'low' | '86'
  notes?: string
  expected_back?: string
  updated_at: string
  menu_item?: {
    item_id: string
    name: string
    price: number
    allergy_flags?: string
    active: boolean
  }
}

export interface Review {
  review_id: string
  source: string
  rating: number
  text: string
  created_at: string
  theme?: string
  url?: string
}

export interface Change {
  change_id: string
  title: string
  detail?: string
  created_by: string
  created_at: string
  is_active: boolean
}

export interface BriefData {
  date: string
  eighty_six_items: InventoryItem[]
  low_stock_items: InventoryItem[]
  recent_reviews: Review[]
  changes: Change[]
  generated_at: string
}

export interface MenuItem {
  item_id: string
  name: string
  price: number
  allergy_flags?: string
  active: boolean
  created_at: string
  updated_at: string
}

// API Functions
export const apiClient = {
  // Health check
  async ping() {
    const response = await api.get('/ping')
    return response.data
  },

  // Brief endpoints
  async getBrief() {
    const response = await api.get('/api/v1/brief/today')
    return response.data as BriefData
  },

  async downloadBriefPDF() {
    const response = await api.get('/api/v1/brief/today/pdf', {
      responseType: 'blob'
    })
    return response.data
  },

  // Inventory endpoints
  async getInventory() {
    const response = await api.get('/api/v1/inventory')
    return response.data as InventoryItem[]
  },

  async createInventoryItem(item: Partial<InventoryItem>) {
    const response = await api.post('/api/v1/inventory', item)
    return response.data as InventoryItem
  },

  async updateInventoryItem(id: number, item: Partial<InventoryItem>) {
    const response = await api.put(`/api/v1/inventory/${id}`, item)
    return response.data as InventoryItem
  },

  async deleteInventoryItem(id: number) {
    const response = await api.delete(`/api/v1/inventory/${id}`)
    return response.data
  },

  async uploadInventoryCSV(file: File) {
    const formData = new FormData()
    formData.append('file', file)
    const response = await api.post('/api/v1/inventory/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })
    return response.data
  },

  // Reviews endpoints
  async getReviews(days: number = 7) {
    const response = await api.get(`/api/v1/reviews?days=${days}`)
    return response.data as Review[]
  },

  // Changes endpoints
  async getChanges() {
    const response = await api.get('/api/v1/changes')
    return response.data as Change[]
  },

  async createChange(change: Partial<Change>) {
    const response = await api.post('/api/v1/changes', change)
    return response.data as Change
  },

  async updateChange(id: string, change: Partial<Change>) {
    const response = await api.put(`/api/v1/changes/${id}`, change)
    return response.data as Change
  },

  async deleteChange(id: string) {
    const response = await api.delete(`/api/v1/changes/${id}`)
    return response.data
  },

  // Menu endpoints
  async getMenuItems() {
    const response = await api.get('/api/v1/menu')
    return response.data as MenuItem[]
  },

  async createMenuItem(item: Partial<MenuItem>) {
    const response = await api.post('/api/v1/menu', item)
    return response.data as MenuItem
  },

  async updateMenuItem(id: string, item: Partial<MenuItem>) {
    const response = await api.put(`/api/v1/menu/${id}`, item)
    return response.data as MenuItem
  },

  async deleteMenuItem(id: string) {
    const response = await api.delete(`/api/v1/menu/${id}`)
    return response.data
  },
}

// Error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error.response?.data || error.message)
    return Promise.reject(error)
  }
)

export default api
