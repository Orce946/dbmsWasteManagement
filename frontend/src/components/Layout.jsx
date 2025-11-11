import React, { useState } from 'react';
import { Menu, X, Home, MapPin, Users, FileText, DollarSign, Trash2, Package, BarChart3 } from 'lucide-react';
import { Link } from 'react-router-dom';

export const Layout = ({ children }) => {
  const [isOpen, setIsOpen] = useState(false);

  const menuItems = [
    { icon: Home, label: 'Dashboard', href: '/' },
    { icon: MapPin, label: 'Areas', href: '/areas' },
    { icon: Users, label: 'Citizens', href: '/citizens' },
    { icon: FileText, label: 'Bills', href: '/bills' },
    { icon: DollarSign, label: 'Payments', href: '/payments' },
    { icon: Trash2, label: 'Waste', href: '/waste' },
    { icon: Package, label: 'Bins', href: '/bins' },
    { icon: BarChart3, label: 'Reports', href: '/reports' },
  ];

  return (
    <div className="min-h-screen bg-gray-100 flex">
      {/* Sidebar */}
      <div className={`fixed md:static inset-y-0 left-0 z-40 w-64 bg-gradient-to-b from-green-600 to-green-700 text-white transform ${isOpen ? 'translate-x-0' : '-translate-x-full'} md:translate-x-0 transition-transform duration-300`}>
        <div className="p-6 border-b border-green-500">
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Trash2 size={28} />
            WasteHub
          </h1>
        </div>
        <nav className="p-4 space-y-2">
          {menuItems.map((item) => (
            <Link
              key={item.href}
              to={item.href}
              className="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-green-500 transition-colors"
              onClick={() => setIsOpen(false)}
            >
              <item.icon size={20} />
              {item.label}
            </Link>
          ))}
        </nav>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col">
        {/* Header */}
        <header className="bg-white shadow">
          <div className="flex items-center justify-between p-4">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="md:hidden p-2 hover:bg-gray-100 rounded-lg"
            >
              {isOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
            <h2 className="text-xl font-semibold text-gray-800">Waste Management System</h2>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">Welcome</span>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 overflow-auto p-6">
          {children}
        </main>

        {/* Footer */}
        <footer className="bg-gray-800 text-white p-4 text-center">
          <p>&copy; 2025 Waste Management System. All rights reserved.</p>
        </footer>
      </div>

      {/* Mobile menu overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 md:hidden z-30"
          onClick={() => setIsOpen(false)}
        />
      )}
    </div>
  );
};
