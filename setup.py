#!/usr/bin/env python3
"""
Setup script for Restaurant Ops Hub
This script helps set up the development environment
"""

import os
import sys
import subprocess
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e.stderr}")
        return False

def check_docker():
    """Check if Docker is running"""
    try:
        subprocess.run(["docker", "ps"], check=True, capture_output=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def setup_database():
    """Set up the database using Docker"""
    if not check_docker():
        print("❌ Docker is not running. Please start Docker and try again.")
        print("   You can also set up PostgreSQL manually and run migrations.")
        return False
    
    print("🐳 Starting PostgreSQL with Docker...")
    if not run_command("docker-compose up -d postgres", "Starting PostgreSQL"):
        return False
    
    print("⏳ Waiting for PostgreSQL to be ready...")
    import time
    time.sleep(5)
    
    print("🗄️ Running database migrations...")
    if not run_command("python3 -m alembic upgrade head", "Running migrations"):
        return False
    
    print("🌱 Seeding database...")
    if not run_command("python3 -m alembic upgrade head", "Seeding database"):
        return False
    
    return True

def install_dependencies():
    """Install Python dependencies"""
    print("📦 Installing Python dependencies...")
    return run_command("python3 -m pip install -e .", "Installing dependencies")

def install_frontend_dependencies():
    """Install frontend dependencies"""
    print("📦 Installing frontend dependencies...")
    os.chdir("apps/web")
    success = run_command("npm install", "Installing npm packages")
    os.chdir("../..")
    return success

def main():
    """Main setup function"""
    print("🚀 Setting up Restaurant Ops Hub...")
    print("=" * 50)
    
    # Check if we're in the right directory
    if not Path("pyproject.toml").exists():
        print("❌ Please run this script from the project root directory")
        sys.exit(1)
    
    # Install dependencies
    if not install_dependencies():
        print("❌ Failed to install Python dependencies")
        sys.exit(1)
    
    if not install_frontend_dependencies():
        print("❌ Failed to install frontend dependencies")
        sys.exit(1)
    
    # Set up database
    if not setup_database():
        print("⚠️  Database setup failed, but you can continue with development")
        print("   Start Docker and run: docker-compose up -d postgres")
        print("   Then run: python3 -m alembic upgrade head")
    
    print("\n🎉 Setup complete!")
    print("\nNext steps:")
    print("1. Start the backend: python3 -m uvicorn apps.api.main:app --reload")
    print("2. Start the frontend: cd apps/web && npm run dev")
    print("3. Open http://localhost:3000 in your browser")

if __name__ == "__main__":
    main()
