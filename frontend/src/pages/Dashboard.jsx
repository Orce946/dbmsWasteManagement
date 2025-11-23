import React, { useEffect, useState } from 'react';
import { TrendingUp, Users, Trash2, DollarSign } from 'lucide-react';
import { Card } from '../components/UI';
import { billsAPI, wasteAPI, citizensAPI, binsAPI, crewAPI } from '../services/api';
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

export const Dashboard = () => {
  const [stats, setStats] = useState({
    citizens: [],
    waste: [],
    bills: [],
    bins: [],
    crew: [],
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [citizensRes, wasteRes, billsRes, binsRes, crewRes] = await Promise.all([
          citizensAPI.getAll(),
          wasteAPI.getAll(),
          billsAPI.getAll(),
          binsAPI.getAll(),
          crewAPI.getAll(),
        ]);

        setStats({
          citizens: citizensRes.data.data || [],
          waste: wasteRes.data.data || [],
          bills: billsRes.data.data || [],
          bins: binsRes.data.data || [],
          crew: crewRes.data.data || [],
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

  // Calculate statistics
  const totalCitizens = stats.citizens.length;
  const totalWasteCollected = stats.waste.reduce((sum, w) => sum + parseFloat(w.quantity || 0), 0);
  const totalWasteRecycled = stats.waste.filter((w) => w.status === 'Recycled').reduce((sum, w) => sum + parseFloat(w.quantity || 0), 0);
  const totalBillsPaid = stats.bills.filter((b) => b.status === 'Paid').reduce((sum, b) => sum + parseFloat(b.amount || 0), 0);

  // Waste by type chart data
  const wasteByTypeData = stats.waste.reduce((acc, waste) => {
    const existing = acc.find((w) => w.type === waste.waste_type);
    if (existing) {
      existing.quantity += parseFloat(waste.quantity || 0);
      existing.count += 1;
    } else {
      acc.push({ type: waste.waste_type, quantity: parseFloat(waste.quantity || 0), count: 1 });
    }
    return acc;
  }, []);

  // Waste by status chart data
  const wasteByStatusData = stats.waste.reduce((acc, waste) => {
    const existing = acc.find((w) => w.status === waste.status);
    if (existing) {
      existing.count += 1;
      existing.quantity += parseFloat(waste.quantity || 0);
    } else {
      acc.push({ status: waste.status, count: 1, quantity: parseFloat(waste.quantity || 0) });
    }
    return acc;
  }, []);

  // Bills by status chart data
  const billsByStatusData = stats.bills.reduce((acc, bill) => {
    const existing = acc.find((b) => b.status === bill.status);
    if (existing) {
      existing.count += 1;
      existing.amount += parseFloat(bill.amount || 0);
    } else {
      acc.push({ status: bill.status, count: 1, amount: parseFloat(bill.amount || 0) });
    }
    return acc;
  }, []);

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-800">Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <StatCard icon={Users} label="Total Citizens" value={totalCitizens} color="blue" />
        <StatCard icon={Trash2} label="Waste Collected (kg)" value={totalWasteCollected.toFixed(2)} color="yellow" />
        <StatCard icon={TrendingUp} label="Waste Recycled (kg)" value={totalWasteRecycled.toFixed(2)} color="green" />
        <StatCard icon={DollarSign} label="Total Bills Paid ($)" value={totalBillsPaid.toFixed(2)} color="green" />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Waste Status Distribution */}
        <Card>
          <h3 className="text-lg font-bold mb-4">Waste Status Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={wasteByStatusData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ status, count }) => `${status}: ${count}`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="count"
              >
                {COLORS.map((color, index) => (
                  <Cell key={`cell-${index}`} fill={color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </Card>

        {/* Bill Status Distribution */}
        <Card>
          <h3 className="text-lg font-bold mb-4">Bill Status Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={billsByStatusData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ status, count }) => `${status}: ${count}`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="count"
              >
                {COLORS.map((color, index) => (
                  <Cell key={`cell-${index}`} fill={color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </Card>
      </div>

      {/* Waste by Type Chart */}
      {wasteByTypeData.length > 0 && (
        <Card>
          <h3 className="text-lg font-bold mb-4">Waste Collection by Type</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={wasteByTypeData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="type" />
              <YAxis yAxisId="left" />
              <YAxis yAxisId="right" orientation="right" />
              <Tooltip />
              <Legend />
              <Bar yAxisId="left" dataKey="quantity" fill="#f59e0b" name="Total Quantity (kg)" />
              <Bar yAxisId="right" dataKey="count" fill="#3b82f6" name="Number of Records" />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      )}

      {/* Bills by Status Amount Chart */}
      {billsByStatusData.length > 0 && (
        <Card>
          <h3 className="text-lg font-bold mb-4">Bills Amount by Status</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={billsByStatusData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="status" />
              <YAxis yAxisId="left" />
              <YAxis yAxisId="right" orientation="right" />
              <Tooltip />
              <Legend />
              <Bar yAxisId="left" dataKey="amount" fill="#10b981" name="Amount ($)" />
              <Bar yAxisId="right" dataKey="count" fill="#ef4444" name="Number of Bills" />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      )}
    </div>
  );
};
