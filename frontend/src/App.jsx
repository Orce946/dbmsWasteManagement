import React, { Suspense } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Layout } from './components/Layout';
import { Notification } from './components/Notification';
import { NotificationProvider } from './context/NotificationContext';
import { Dashboard } from './pages/Dashboard';
import './index.css';

// Lazy load pages for better performance
const Areas = React.lazy(() => import('./pages/Areas').then(m => ({ default: m.Areas })));
const Bills = React.lazy(() => import('./pages/Bills').then(m => ({ default: m.Bills })));
const Citizens = React.lazy(() => import('./pages/Citizens').then(m => ({ default: m.Citizens })));
const Waste = React.lazy(() => import('./pages/Waste').then(m => ({ default: m.Waste })));
const Bins = React.lazy(() => import('./pages/Bins').then(m => ({ default: m.Bins })));
const Crew = React.lazy(() => import('./pages/Crew').then(m => ({ default: m.Crew })));
const CollectionSchedules = React.lazy(() => import('./pages/CollectionSchedules').then(m => ({ default: m.CollectionSchedules })));
const RecyclingCenters = React.lazy(() => import('./pages/RecyclingCenters').then(m => ({ default: m.RecyclingCenters })));

// Loading component
const PageLoader = () => (
  <div className="flex items-center justify-center h-screen">
    <div className="text-center">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
      <p className="text-gray-600">Loading...</p>
    </div>
  </div>
);

function App() {
  return (
    <NotificationProvider>
      <Router>
        <Layout>
          <Suspense fallback={<PageLoader />}>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/areas" element={<Areas />} />
              <Route path="/bills" element={<Bills />} />
              <Route path="/citizens" element={<Citizens />} />
              <Route path="/waste" element={<Waste />} />
              <Route path="/bins" element={<Bins />} />
              <Route path="/crew" element={<Crew />} />
              <Route path="/schedules" element={<CollectionSchedules />} />
              <Route path="/centers" element={<RecyclingCenters />} />
            </Routes>
          </Suspense>
          <Notification />
        </Layout>
      </Router>
    </NotificationProvider>
  );
}

export default App;
