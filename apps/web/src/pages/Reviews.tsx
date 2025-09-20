import { useState } from 'react'
import { Star, Filter, Download } from 'lucide-react'

interface Review {
  review_id: string
  source: string
  rating: number
  text: string
  created_at: string
  theme?: string
}

export default function Reviews() {
  const [reviews, setReviews] = useState<Review[]>([
    {
      review_id: '1',
      source: 'Google',
      rating: 5,
      text: 'Excellent food and service! The staff was very friendly and the food came out quickly.',
      created_at: '2024-01-15T10:00:00Z',
      theme: 'positive'
    },
    {
      review_id: '2',
      source: 'Google',
      rating: 3,
      text: 'Food was okay but service was slow. Had to wait 45 minutes for our order.',
      created_at: '2024-01-15T08:00:00Z',
      theme: 'service'
    },
    {
      review_id: '3',
      source: 'Yelp',
      rating: 4,
      text: 'Great atmosphere and good food. Will definitely come back!',
      created_at: '2024-01-14T15:30:00Z',
      theme: 'positive'
    },
    {
      review_id: '4',
      source: 'Google',
      rating: 2,
      text: 'Food was cold when it arrived. Not worth the price.',
      created_at: '2024-01-14T12:00:00Z',
      theme: 'food_quality'
    }
  ])

  const [ratingFilter, setRatingFilter] = useState<'all' | '5' | '4' | '3' | '2' | '1'>('all')
  const [sourceFilter, setSourceFilter] = useState<'all' | 'Google' | 'Yelp'>('all')

  const filteredReviews = reviews.filter(review => {
    const matchesRating = ratingFilter === 'all' || review.rating.toString() === ratingFilter
    const matchesSource = sourceFilter === 'all' || review.source === sourceFilter
    return matchesRating && matchesSource
  })

  const getRatingStars = (rating: number) => {
    return [...Array(5)].map((_, i) => (
      <span
        key={i}
        className={`text-lg ${
          i < rating ? 'text-yellow-400' : 'text-gray-300'
        }`}
      >
        ★
      </span>
    ))
  }

  const getThemeBadge = (theme?: string) => {
    if (!theme) return null
    
    const baseClasses = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    switch (theme) {
      case 'positive':
        return `${baseClasses} bg-success-100 text-success-800`
      case 'service':
        return `${baseClasses} bg-warning-100 text-warning-800`
      case 'food_quality':
        return `${baseClasses} bg-danger-100 text-danger-800`
      default:
        return `${baseClasses} bg-gray-100 text-gray-800`
    }
  }

  const averageRating = reviews.reduce((sum, review) => sum + review.rating, 0) / reviews.length

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Customer Reviews</h1>
          <p className="mt-1 text-sm text-gray-500">
            Monitor customer feedback and sentiment
          </p>
        </div>
        <div className="flex space-x-3">
          <button className="btn btn-secondary flex items-center">
            <Download className="h-4 w-4 mr-2" />
            Export
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-3">
        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Star className="h-8 w-8 text-yellow-400" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Average Rating</p>
              <p className="text-2xl font-semibold text-gray-900">
                {averageRating.toFixed(1)}
              </p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <span className="text-2xl font-semibold text-gray-900">{reviews.length}</span>
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Total Reviews</p>
              <p className="text-sm text-gray-400">Last 30 days</p>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <span className="text-2xl font-semibold text-success-600">
                {Math.round((reviews.filter(r => r.rating >= 4).length / reviews.length) * 100)}%
              </span>
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Positive Reviews</p>
              <p className="text-sm text-gray-400">4+ stars</p>
            </div>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex space-x-2">
            <button
              onClick={() => setRatingFilter('all')}
              className={`btn ${ratingFilter === 'all' ? 'btn-primary' : 'btn-secondary'}`}
            >
              All Ratings
            </button>
            {[5, 4, 3, 2, 1].map(rating => (
              <button
                key={rating}
                onClick={() => setRatingFilter(rating.toString() as any)}
                className={`btn ${ratingFilter === rating.toString() ? 'btn-primary' : 'btn-secondary'}`}
              >
                {rating}★
              </button>
            ))}
          </div>
          <div className="flex space-x-2">
            <button
              onClick={() => setSourceFilter('all')}
              className={`btn ${sourceFilter === 'all' ? 'btn-primary' : 'btn-secondary'}`}
            >
              All Sources
            </button>
            <button
              onClick={() => setSourceFilter('Google')}
              className={`btn ${sourceFilter === 'Google' ? 'btn-primary' : 'btn-secondary'}`}
            >
              Google
            </button>
            <button
              onClick={() => setSourceFilter('Yelp')}
              className={`btn ${sourceFilter === 'Yelp' ? 'btn-primary' : 'btn-secondary'}`}
            >
              Yelp
            </button>
          </div>
        </div>
      </div>

      {/* Reviews List */}
      <div className="space-y-4">
        {filteredReviews.map((review) => (
          <div key={review.review_id} className="card">
            <div className="flex items-start justify-between">
              <div className="flex-1">
                <div className="flex items-center space-x-3 mb-2">
                  <div className="flex">
                    {getRatingStars(review.rating)}
                  </div>
                  <span className="text-sm font-medium text-gray-900">{review.source}</span>
                  <span className="text-sm text-gray-500">
                    {new Date(review.created_at).toLocaleDateString()}
                  </span>
                  {getThemeBadge(review.theme)}
                </div>
                <p className="text-gray-900">{review.text}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {filteredReviews.length === 0 && (
        <div className="text-center py-12">
          <Star className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-medium text-gray-900">No reviews found</h3>
          <p className="mt-1 text-sm text-gray-500">
            Try adjusting your filters to see more reviews.
          </p>
        </div>
      )}
    </div>
  )
}
