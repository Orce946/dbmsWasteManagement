import React, { useEffect, useState, useContext } from 'react';
import { Card, Button, Modal, Form, Table, Badge } from '../components/UI';
import { billsAPI, citizensAPI } from '../services/api';
import { NotificationContext } from '../context/NotificationContext';
import { Plus, Edit, Trash2 } from 'lucide-react';

export const Bills = () => {
  const { showNotification } = useContext(NotificationContext);
  const [bills, setBills] = useState([]);
  const [citizens, setCitizens] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchBills();
    fetchCitizens();
  }, []);

  const fetchBills = async () => {
    try {
      const response = await billsAPI.getAll();
      setBills(response.data.data || []);
    } catch (error) {
      showNotification('Error fetching bills', 'error');
    } finally {
      setLoading(false);
    }
  };

  const fetchCitizens = async () => {
    try {
      const response = await citizensAPI.getAll();
      setCitizens(response.data.data || []);
    } catch (error) {
      console.error('Error fetching citizens:', error);
    }
  };

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      if (editingId) {
        await billsAPI.updateStatus(editingId, formData.status);
        showNotification('Bill updated successfully', 'success');
      } else {
        await billsAPI.create(formData);
        showNotification('Bill created successfully', 'success');
      }
      setIsModalOpen(false);
      setEditingId(null);
      fetchBills();
    } catch (error) {
      showNotification(error.response?.data?.error || 'Error saving bill', 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure?')) {
      try {
        await billsAPI.delete(id);
        showNotification('Bill deleted successfully', 'success');
        fetchBills();
      } catch (error) {
        showNotification(error.response?.data?.error || 'Error deleting bill', 'error');
      }
    }
  };

  const getStatusBadge = (status) => {
    const variants = {
      'Paid': 'success',
      'Pending': 'warning',
      'Overdue': 'danger',
    };
    return <Badge variant={variants[status] || 'primary'}>{status}</Badge>;
  };

  if (loading) return <div className="text-center py-8">Loading...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-800">Bills</h1>
        <Button
          variant="primary"
          onClick={() => {
            setEditingId(null);
            setIsModalOpen(true);
          }}
          className="flex items-center gap-2"
        >
          <Plus size={20} />
          Add Bill
        </Button>
      </div>

      <Card>
        <Table
          headers={['Bill ID', 'Citizen', 'Amount', 'Status', 'Due Date']}
          rows={bills.map((bill) => ({
            id: bill.bill_id,
            citizen: bill.citizen_name || '-',
            amount: `$${bill.amount}`,
            status: getStatusBadge(bill.status),
            due: new Date(bill.due_date).toLocaleDateString(),
          }))}
          actions={(row) => [
            <Button
              key="edit"
              variant="secondary"
              size="sm"
              onClick={() => setEditingId(row.id) || setIsModalOpen(true)}
              className="text-sm px-2 py-1"
            >
              <Edit size={16} />
            </Button>,
            <Button
              key="delete"
              variant="danger"
              size="sm"
              onClick={() => handleDelete(row.id)}
              className="text-sm px-2 py-1"
            >
              <Trash2 size={16} />
            </Button>,
          ]}
        />
      </Card>

      <Modal
        isOpen={isModalOpen}
        onClose={() => {
          setIsModalOpen(false);
          setEditingId(null);
        }}
        title={editingId ? 'Edit Bill' : 'Add New Bill'}
      >
        <Form
          onSubmit={handleSubmit}
          isLoading={isSubmitting}
          fields={[
            {
              name: 'citizen_id',
              label: 'Citizen',
              type: 'select',
              required: true,
            },
            {
              name: 'status',
              label: 'Status',
              type: 'select',
              required: true,
              value: editingId ? bills.find((b) => b.bill_id === editingId)?.status || '' : '',
            },
            {
              name: 'amount',
              label: 'Amount',
              type: 'number',
              required: true,
            },
            {
              name: 'due_date',
              label: 'Due Date',
              type: 'date',
              required: true,
            },
          ]}
          submitLabel={editingId ? 'Update Bill' : 'Create Bill'}
        />
      </Modal>
    </div>
  );
};
