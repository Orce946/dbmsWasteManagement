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
  const [deleting, setDeleting] = useState(false);

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

  const handleDelete = async (areaId) => {
    const areaIdNum = parseInt(areaId, 10);
    console.log('🗑️ Delete initiated for area ID:', areaIdNum, 'Type:', typeof areaIdNum);
    
    if (!window.confirm('Are you sure you want to delete this area?')) {
      console.log('❌ Delete cancelled by user');
      return;
    }

    setDeleting(true);
    try {
      console.log('📤 Sending DELETE request to /areas/' + areaIdNum);
      const response = await areasAPI.delete(areaIdNum);
      console.log('📥 Delete response:', response.data);
      
      if (response.data.success) {
        showNotification(response.data.message || 'Area deleted successfully', 'success');
        console.log('✅ Area deleted successfully');
        await fetchAreas();
      } else {
        showNotification(response.data.error || 'Error deleting area', 'error');
        console.error('❌ Delete failed:', response.data.error);
      }
    } catch (error) {
      const errorMsg = error.response?.data?.error || error.message || 'Error deleting area';
      console.error('❌ Delete error:', error);
      showNotification(errorMsg, 'error');
    } finally {
      setDeleting(false);
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
        {areas.length === 0 ? (
          <div className="text-center py-8 text-gray-500">No areas found. Create one to get started!</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr className="bg-gray-100">
                  <th className="px-6 py-3 text-left font-medium text-gray-700">Area ID</th>
                  <th className="px-6 py-3 text-left font-medium text-gray-700">Name</th>
                  <th className="px-6 py-3 text-left font-medium text-gray-700">Description</th>
                  <th className="px-6 py-3 text-left font-medium text-gray-700">Created At</th>
                  <th className="px-6 py-3 text-left font-medium text-gray-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                {areas.map((area, index) => (
                  <tr key={area.area_id} className="border-b border-gray-200 hover:bg-gray-50">
                    <td className="px-6 py-4">{area.area_id}</td>
                    <td className="px-6 py-4 font-medium">{area.area_name}</td>
                    <td className="px-6 py-4">{area.description || '-'}</td>
                    <td className="px-6 py-4">{new Date(area.created_at).toLocaleDateString()}</td>
                    <td className="px-6 py-4 flex gap-2">
                      <Button
                        variant="secondary"
                        size="sm"
                        onClick={() => handleEdit(area)}
                        className="text-sm px-2 py-1"
                        title="Edit area"
                        disabled={deleting}
                      >
                        <Edit size={16} />
                      </Button>
                      <Button
                        variant="danger"
                        size="sm"
                        onClick={() => handleDelete(area.area_id)}
                        className="text-sm px-2 py-1"
                        title="Delete area"
                        disabled={deleting}
                      >
                        <Trash2 size={16} />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
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
