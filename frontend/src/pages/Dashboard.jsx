import React, { useEffect, useState } from 'react';
import { TrendingUp, Users, FileText, DollarSign } from 'lucide-react';
import { Card } from '../components/UI';
import { billsAPI, paymentsAPI, wasteAPI } from '../services/api';
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

export const Dashboard = () => {
  const [stats, setStats] = useState({
    bills: null,
    payments: null,
    waste: null,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [billsRes, paymentsRes, wasteRes] = await Promise.all([
          billsAPI.getStatistics(),
          paymentsAPI.getStatistics(),
          wasteAPI.getStatistics(),
        ]);

        setStats({
          bills: billsRes.data.data,
          payments: paymentsRes.data.data,
          waste: wasteRes.data.data,
        });
      } catch (error) {
        console.error('Error fetching stats:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  const StatCard = ({ icon: Icon, label, value, color }) => (
    <Card className={`bg-gradient-to-br from-${color}-50 to-${color}-100 border-l-4 border-${color}-500`}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm font-medium">{label}</p>
          <p className="text-3xl font-bold text-gray-800 mt-2">{value || '0'}</p>
        </div>
        <Icon size={48} className={`text-${color}-500 opacity-20`} />
      </div>
    </Card>
  );

  const COLORS = ['#10b981', '#3b82f6', '#f59e0b', '#ef4444'];

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-800">Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <StatCard icon={FileText} label="Total Bills" value={stats.bills?.total_bills} color="blue" />
        <StatCard icon={DollarSign} label="Total Amount" value={`$${stats.bills?.total_amount || 0}`} color="green" />
        <StatCard icon={TrendingUp} label="Paid Bills" value={stats.bills?.paid_count} color="green" />
        <StatCard icon={Users} label="Pending Bills" value={stats.bills?.pending_count} color="yellow" />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Bill Status Chart */}
        <Card>
          <h3 className="text-lg font-bold mb-4">Bill Status Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={[
                  { name: 'Paid', value: stats.bills?.paid_count || 0 },
                  { name: 'Pending', value: stats.bills?.pending_count || 0 },
                  { name: 'Overdue', value: stats.bills?.overdue_count || 0 },
                ]}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, value }) => `${name}: ${value}`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="value"
              >
                {COLORS.map((color, index) => (
                  <Cell key={`cell-${index}`} fill={color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </Card>

        {/* Payment Methods Chart */}
        <Card>
          <h3 className="text-lg font-bold mb-4">Payment Methods Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart
              data={[
                { method: 'Cash', count: stats.payments?.cash_payments || 0 },
                { method: 'Card', count: stats.payments?.card_payments || 0 },
                { method: 'Online', count: stats.payments?.online_payments || 0 },
                { method: 'Check', count: stats.payments?.check_payments || 0 },
              ]}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="method" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#10b981" />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      </div>

      {/* Waste Statistics */}
      {stats.waste && stats.waste.length > 0 && (
        <Card>
          <h3 className="text-lg font-bold mb-4">Waste by Category</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={stats.waste}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="category" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="total_quantity" fill="#f59e0b" name="Total Quantity" />
              <Bar dataKey="count" fill="#3b82f6" name="Count" />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      )}
    </div>
  );
};
