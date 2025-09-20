# 🍽️ Restaurant Ops Hub

A modern, modular web application for restaurants to centralize operations like pre-shift briefs, 86 boards, reviews, and checklists.

## ✨ Features

### MVP Features (Phase 1)
- **Pre-Shift Brief Generator**: Pulls 86 list, low stock items, recent reviews, change log; outputs PDF and Slack link
- **Live 86 Board**: Sync from POS via CSV upload; allow manual overrides
- **Change Log / Announcements**: Managers enter updates; staff can acknowledge
- **Review Ingest**: Pull Google reviews via API; basic sentiment analysis; store in DB; show in dashboard

### Planned Features (Phase 2+)
- Low-stock prediction
- Clustering review themes
- Section heatmaps
- Checklists with sign-off
- POS API sync
- Scheduling sync
- Ticket time monitor
- Staff quizzes
- Maintenance log

## 🏗️ Architecture

### Backend
- **FastAPI** REST API with modular services
- **PostgreSQL** database with Alembic migrations
- **SQLAlchemy** ORM with async support
- **WeasyPrint** for PDF generation
- **Redis** for caching and background tasks

### Frontend
- **React 18** with TypeScript
- **Vite** for fast development and building
- **Tailwind CSS** for styling
- **React Router** for navigation
- **Lucide React** for icons

### Database Schema
- `users` - User management with roles
- `menus` - Menu items with pricing and allergy info
- `inventory` - Stock status tracking
- `reviews` - Customer feedback with sentiment analysis
- `changes` - Announcements and updates
- `shifts` - Staff scheduling
- `acknowledgements` - Staff acknowledgment tracking

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- Node.js 18+
- Docker (optional, for database)
- PostgreSQL (if not using Docker)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd restaurant-ops-hub
   ```

2. **Run the setup script**
   ```bash
   python3 setup.py
   ```

   Or manually:

3. **Install Python dependencies**
   ```bash
   pip install -e .
   ```

4. **Install frontend dependencies**
   ```bash
   cd apps/web
   npm install
   cd ../..
   ```

5. **Set up the database**
   
   **Option A: Using Docker (Recommended)**
   ```bash
   docker-compose up -d postgres
   python3 -m alembic upgrade head
   ```
   
   **Option B: Manual PostgreSQL setup**
   ```bash
   # Create database
   createdb restaurant_ops
   
   # Run migrations
   python3 -m alembic upgrade head
   ```

6. **Start the development servers**
   
   **Backend:**
   ```bash
   python3 -m uvicorn apps.api.main:app --reload
   ```
   
   **Frontend:**
   ```bash
   cd apps/web
   npm run dev
   ```

7. **Open your browser**
   - Frontend: http://localhost:3000
   - API Docs: http://localhost:8000/docs

## 📁 Project Structure

```
restaurant-ops-hub/
├── apps/
│   ├── api/                    # FastAPI backend
│   │   ├── main.py            # Main API application
│   │   ├── schemas.py         # Pydantic models
│   │   ├── config.py          # Configuration
│   │   └── adapter_registry.py # Adapter pattern
│   └── web/                   # React frontend
│       ├── src/
│       │   ├── components/    # Reusable components
│       │   ├── pages/         # Page components
│       │   ├── App.tsx        # Main app component
│       │   └── main.tsx       # Entry point
│       ├── package.json
│       └── vite.config.ts
├── packages/
│   └── core/                  # Shared domain logic
│       ├── database.py        # SQLAlchemy models
│       ├── domain.py          # Domain entities
│       ├── services.py        # Business logic
│       ├── pdf_service.py     # PDF generation
│       └── ports.py           # Interface definitions
├── infra/
│   └── db/
│       ├── migrations/        # Alembic migrations
│       └── seed.sql          # Sample data
├── tests/                     # Test files
├── docker-compose.yml        # Docker services
├── Dockerfile.api           # Backend Docker image
├── Dockerfile.web           # Frontend Docker image
└── setup.py                 # Setup script
```

## 🔧 Development

### Database Migrations
```bash
# Create a new migration
python3 -m alembic revision --autogenerate -m "Description"

# Apply migrations
python3 -m alembic upgrade head

# Rollback migration
python3 -m alembic downgrade -1
```

### Frontend Development
```bash
cd apps/web
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
```

### API Development
```bash
# Start with auto-reload
python3 -m uvicorn apps.api.main:app --reload

# Run tests
python3 -m pytest

# Check code formatting
python3 -m black .
python3 -m isort .
```

## 🐳 Docker Deployment

### Development
```bash
docker-compose up
```

### Production
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 📊 API Endpoints

### Core Endpoints
- `GET /ping` - Health check
- `GET /health` - System health with adapters
- `GET /api/v1/brief/today` - Generate today's pre-shift brief
- `GET /api/v1/brief/today/pdf` - Download brief as PDF
- `GET /api/v1/inventory` - Get inventory status
- `GET /api/v1/reviews` - Get recent reviews
- `GET /api/v1/changes` - Get active changes

### Legacy Endpoints (for backward compatibility)
- `GET /inventory` - Legacy inventory endpoint
- `GET /reviews` - Legacy reviews endpoint
- `GET /themes` - Review themes analysis

## 🎨 UI Components

### Pages
- **Dashboard**: Overview with stats and quick actions
- **Brief**: Pre-shift brief generation and PDF export
- **Inventory**: 86 board and stock management
- **Reviews**: Customer feedback with filtering
- **Changes**: Announcements and updates management

### Design System
- **Colors**: Primary (blue), Success (green), Warning (yellow), Danger (red)
- **Components**: Buttons, cards, inputs, status badges
- **Layout**: Responsive sidebar navigation
- **Icons**: Lucide React icon library

## 🔒 Environment Variables

Create a `.env` file in the project root:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=restaurant_ops
DB_USER=postgres
DB_PASSWORD=postgres

# API
NEXT_PUBLIC_API=http://localhost:8000

# External Services
GOOGLE_LOCATION_ID=your_location_id
IMAP_URL=your_imap_url
IMAP_USER=your_email
IMAP_PASS=your_password

# Adapters
ADAPTERS=mock,google,imap
```

## 🧪 Testing

```bash
# Run all tests
python3 -m pytest

# Run with coverage
python3 -m pytest --cov=packages

# Run frontend tests
cd apps/web && npm test
```

## 📈 Monitoring

- **Health Checks**: `/ping` and `/health` endpoints
- **Logging**: Structured logging with Python logging
- **Metrics**: Ready for Prometheus integration
- **Error Tracking**: Sentry integration ready

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation
- Review the API docs at `/docs`

## 🗺️ Roadmap

### Phase 1 (Current)
- ✅ Core MVP features
- ✅ Database setup
- ✅ PDF export
- ✅ Basic UI

### Phase 2 (Next)
- [ ] Real API integrations
- [ ] Advanced analytics
- [ ] Mobile optimization
- [ ] Authentication

### Phase 3 (Future)
- [ ] ML predictions
- [ ] Advanced reporting
- [ ] Multi-restaurant support
- [ ] Mobile app

---

**Built with ❤️ for restaurant operations**