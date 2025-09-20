import { useState, useEffect } from 'react'
import { Download, RefreshCw } from 'lucide-react'
import { apiClient, BriefData } from '../lib/api'

export default function Brief() {
  const [briefData, setBriefData] = useState<BriefData | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchBriefData()
  }, [])

  const fetchBriefData = async () => {
    try {
      setLoading(true)
      const data = await apiClient.getBrief()
      setBriefData(data)
    } catch (error) {
      console.error('Failed to fetch brief data:', error)
      // Fallback to mock data on error
      setBriefData({
        date: new Date().toISOString().split('T')[0],
        eighty_six_items: [],
        low_stock_items: [],
        recent_reviews: [],
        changes: [],
        generated_at: new Date().toISOString()
      })
    } finally {
      setLoading(false)
    }
  }

  const handleGenerateBrief = async () => {
    await fetchBriefData()
  }

  const handleDownloadPDF = () => {
    // Download PDF from API
    const link = document.createElement('a')
    link.href = '/api/v1/brief/today/pdf'
    link.download = `pre-shift-brief-${new Date().toISOString().split('T')[0]}.pdf`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

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
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Pre-Shift Brief</h1>
          <p className="mt-1 text-sm text-gray-500">
            Generated on {briefData?.date} at {new Date(briefData?.generated_at || '').toLocaleTimeString()}
          </p>
        </div>
        <div className="flex space-x-3">
          <button
            onClick={handleGenerateBrief}
            className="btn btn-secondary flex items-center"
          >
            <RefreshCw className="h-4 w-4 mr-2" />
            Regenerate
          </button>
          <button
            onClick={handleDownloadPDF}
            className="btn btn-primary flex items-center"
          >
            <Download className="h-4 w-4 mr-2" />
            Download PDF
          </button>
        </div>
      </div>

      {/* 86 Items */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
          <span className="w-3 h-3 bg-danger-500 rounded-full mr-2"></span>
          86 Items ({briefData?.eighty_six_items.length || 0})
        </h2>
        {briefData?.eighty_six_items.length === 0 ? (
          <p className="text-gray-500">No items are currently 86'd</p>
        ) : (
          <div className="space-y-2">
            {briefData?.eighty_six_items.map((item) => (
              <div key={item.id} className="flex justify-between items-center p-3 bg-danger-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{item.menu_item?.name || 'Unknown Item'}</p>
                  <p className="text-sm text-gray-500">{item.item_id}</p>
                </div>
                <p className="text-sm text-danger-600">{item.notes}</p>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Low Stock Items */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
          <span className="w-3 h-3 bg-warning-500 rounded-full mr-2"></span>
          Low Stock Items ({briefData?.low_stock_items.length || 0})
        </h2>
        {briefData?.low_stock_items.length === 0 ? (
          <p className="text-gray-500">All items are well stocked</p>
        ) : (
          <div className="space-y-2">
            {briefData?.low_stock_items.map((item) => (
              <div key={item.id} className="flex justify-between items-center p-3 bg-warning-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{item.menu_item?.name || 'Unknown Item'}</p>
                  <p className="text-sm text-gray-500">{item.item_id}</p>
                </div>
                <p className="text-sm text-warning-600">{item.notes}</p>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Recent Reviews */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Reviews</h2>
        <div className="space-y-3">
          {briefData?.recent_reviews.map((review) => (
            <div key={review.review_id} className="border-l-4 border-primary-200 pl-4">
              <div className="flex items-center space-x-2 mb-1">
                <div className="flex">
                  {[...Array(5)].map((_, i) => (
                    <span
                      key={i}
                      className={`text-sm ${
                        i < review.rating ? 'text-yellow-400' : 'text-gray-300'
                      }`}
                    >
                      ★
                    </span>
                  ))}
                </div>
                <span className="text-sm text-gray-500">{review.source}</span>
                <span className="text-sm text-gray-400">
                  {new Date(review.created_at).toLocaleDateString()}
                </span>
              </div>
              <p className="text-gray-900">{review.text}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Changes & Announcements */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Changes & Announcements</h2>
        <div className="space-y-3">
          {briefData?.changes.map((change) => (
            <div key={change.change_id} className="border-l-4 border-primary-500 pl-4">
              <h3 className="font-medium text-gray-900">{change.title}</h3>
              <p className="text-sm text-gray-600 mt-1">{change.detail}</p>
              <p className="text-xs text-gray-400 mt-1">
                {new Date(change.created_at).toLocaleString()}
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
