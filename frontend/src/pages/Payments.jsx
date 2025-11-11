import React, { useEffect, useState, useContext } from 'react';
import { Card, Button, Modal, Form, Table } from '../components/UI';
import { paymentsAPI, billsAPI } from '../services/api';
import { NotificationContext } from '../context/NotificationContext';
import { Plus, Trash2 } from 'lucide-react';

export const Payments = () => {
  const { showNotification } = useContext(NotificationContext);
  const [payments, setPayments] = useState([]);
  const [bills, setBills] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchPayments();
    fetchBills();
  }, []);

  const fetchPayments = async () => {
    try {
      const response = await paymentsAPI.getAll();
      setPayments(response.data.data || []);
    } catch (error) {
      showNotification('Error fetching payments', 'error');
    } finally {
      setLoading(false);
    }
  };

  const fetchBills = async () => {
    try {
      const response = await billsAPI.getAll();
      setBills(response.data.data || []);
    } catch (error) {
      console.error('Error fetching bills:', error);
    }
  };

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      await paymentsAPI.create(formData);
      showNotification('Payment recorded successfully', 'success');
      setIsModalOpen(false);
      fetchPayments();
      fetchBills();
    } catch (error) {
      showNotification(error.response?.data?.error || 'Error recording payment', 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  if (loading) return <div className="text-center py-8">Loading...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-800">Payments</h1>
        <Button
          variant="primary"
          onClick={() => setIsModalOpen(true)}
          className="flex items-center gap-2"
        >
          <Plus size={20} />
          Record Payment
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="bg-gradient-to-br from-green-50 to-green-100">
          <p className="text-gray-600 text-sm">Total Payments</p>
          <p className="text-3xl font-bold text-green-600">
            ${payments.reduce((sum, p) => sum + parseFloat(p.amount), 0).toFixed(2)}
          </p>
        </Card>
        <Card className="bg-gradient-to-br from-blue-50 to-blue-100">
          <p className="text-gray-600 text-sm">Total Transactions</p>
          <p className="text-3xl font-bold text-blue-600">{payments.length}</p>
        </Card>
        <Card className="bg-gradient-to-br from-purple-50 to-purple-100">
          <p className="text-gray-600 text-sm">Average Payment</p>
          <p className="text-3xl font-bold text-purple-600">
            ${payments.length > 0 ? (payments.reduce((sum, p) => sum + parseFloat(p.amount), 0) / payments.length).toFixed(2) : '0'}
          </p>
        </Card>
      </div>

      <Card>
        <Table
          headers={['Payment ID', 'Citizen', 'Bill ID', 'Amount', 'Method', 'Date']}
          rows={payments.map((payment) => ({
            id: payment.payment_id,
            citizen: payment.citizen_name || '-',
            bill: payment.bill_id,
            amount: `$${payment.amount}`,
            method: payment.payment_method,
            date: new Date(payment.created_at).toLocaleDateString(),
          }))}
        />
      </Card>

      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Record New Payment"
      >
        <Form
          onSubmit={handleSubmit}
          isLoading={isSubmitting}
          fields={[
            {
              name: 'bill_id',
              label: 'Bill',
              type: 'select',
              required: true,
            },
            {
              name: 'amount',
              label: 'Amount',
              type: 'number',
              required: true,
              placeholder: '0.00',
            },
            {
              name: 'payment_method',
              label: 'Payment Method',
              type: 'select',
              required: true,
            },
          ]}
          submitLabel="Record Payment"
        />
      </Modal>
    </div>
  );
};
