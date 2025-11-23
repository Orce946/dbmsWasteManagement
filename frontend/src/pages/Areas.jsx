import React, { useEffect, useState, useContext } from 'react';
import { Card, Button, Modal, Form, Table } from '../components/UI';
import { areasAPI } from '../services/api';
import { NotificationContext } from '../context/NotificationContext';
import { Plus, Edit, Trash2 } from 'lucide-react';

export const Areas = () => {
  const { showNotification } = useContext(NotificationContext);
  const [areas, setAreas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchAreas();
  }, []);

  const fetchAreas = async () => {
    try {
      const response = await areasAPI.getAll();
      setAreas(response.data.data || []);
    } catch (error) {
      showNotification('Error fetching areas', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      if (editingId) {
        await areasAPI.update(editingId, formData);
        showNotification('Area updated successfully', 'success');
      } else {
        await areasAPI.create(formData);
        showNotification('Area created successfully', 'success');
      }
      setIsModalOpen(false);
      setEditingId(null);
      fetchAreas();
    } catch (error) {
      showNotification(error.response?.data?.error || 'Error saving area', 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id) => {
    console.log('Delete button clicked for area:', id);
    if (window.confirm('Are you sure you want to delete this area?')) {
      try {
        console.log('Sending DELETE request for area:', id);
        const response = await areasAPI.delete(id);
        console.log('Delete response:', response);
        if (response.data.success) {
          showNotification(response.data.message || 'Area deleted successfully', 'success');
          await fetchAreas();
        } else {
          showNotification(response.data.error || 'Error deleting area', 'error');
        }
      } catch (error) {
        const errorMsg = error.response?.data?.error || error.message || 'Error deleting area';
        console.error('Delete error:', error);
        showNotification(errorMsg, 'error');
      }
    }
  };

  const handleEdit = (area) => {
    setEditingId(area.area_id);
    setIsModalOpen(true);
  };

  if (loading) return <div className="text-center py-8">Loading...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-800">Areas</h1>
        <Button
          variant="primary"
          onClick={() => {
            setEditingId(null);
            setIsModalOpen(true);
          }}
          className="flex items-center gap-2"
        >
          <Plus size={20} />
          Add Area
        </Button>
      </div>

      <Card>
        <Table
          headers={['Area ID', 'Name', 'Description', 'Created At']}
          rows={areas.map((area) => ({
            id: area.area_id,
            name: area.area_name,
            description: area.description || '-',
            created: new Date(area.created_at).toLocaleDateString(),
          }))}
          actions={(row) => [
            <Button
              key="edit"
              variant="secondary"
              size="sm"
              onClick={() => handleEdit(areas.find((a) => a.area_id == row.id))}
              className="text-sm px-2 py-1"
              title="Edit area"
            >
              <Edit size={16} />
            </Button>,
            <Button
              key="delete"
              variant="danger"
              size="sm"
              onClick={() => handleDelete(row.id)}
              className="text-sm px-2 py-1"
              title="Delete area"
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
        title={editingId ? 'Edit Area' : 'Add New Area'}
      >
        <Form
          key={editingId || 'new'}
          onSubmit={handleSubmit}
          isLoading={isSubmitting}
          fields={[
            {
              name: 'area_name',
              label: 'Area Name',
              placeholder: 'e.g., Downtown',
              required: true,
              value: editingId
                ? areas.find((a) => a.area_id === editingId)?.area_name || ''
                : '',
            },
            {
              name: 'description',
              label: 'Description',
              type: 'textarea',
              placeholder: 'Area description...',
              value: editingId
                ? areas.find((a) => a.area_id === editingId)?.description || ''
                : '',
            },
          ]}
          submitLabel={editingId ? 'Update Area' : 'Create Area'}
        />
      </Modal>
    </div>
  );
};
