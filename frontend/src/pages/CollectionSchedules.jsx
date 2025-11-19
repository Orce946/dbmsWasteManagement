import React, { useEffect, useState, useContext } from 'react';
import { Card, Button, Modal, Form, Table } from '../components/UI';
import { schedulesAPI, areasAPI } from '../services/api';
import { NotificationContext } from '../context/NotificationContext';
import { Plus, Trash2 } from 'lucide-react';

export const CollectionSchedules = () => {
  const { showNotification } = useContext(NotificationContext);
  const [schedules, setSchedules] = useState([]);
  const [areas, setAreas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [schedulesRes, areasRes] = await Promise.all([
        schedulesAPI.getAll(),
        areasAPI.getAll(),
      ]);
      setSchedules(schedulesRes.data.data || []);
      setAreas(areasRes.data.data || []);
    } catch (error) {
      showNotification('Error fetching schedules', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      await schedulesAPI.create(formData);
      showNotification('Schedule created successfully', 'success');
      setIsModalOpen(false);
      fetchData();
    } catch (error) {
      showNotification(error.response?.data?.error || 'Error creating schedule', 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure?')) {
      try {
        await schedulesAPI.delete(id);
        showNotification('Schedule deleted successfully', 'success');
        fetchData();
      } catch (error) {
        showNotification(error.response?.data?.error || 'Error deleting schedule', 'error');
      }
    }
  };

  const getAreaName = (areaId) => {
    const area = areas.find((a) => a.area_id == areaId);
    return area ? area.area_name : 'N/A';
  };

  if (loading) return <div className="text-center py-8">Loading...</div>;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-800">Collection Schedules</h1>
        <Button
          variant="primary"
          onClick={() => setIsModalOpen(true)}
          className="flex items-center gap-2"
        >
          <Plus size={20} />
          Create Schedule
        </Button>
      </div>

      <Card>
        <Table
          headers={['Schedule ID', 'Area', 'Date', 'Created At']}
          rows={schedules.map((schedule) => ({
            id: schedule.schedule_id,
            area: getAreaName(schedule.area_id),
            date: new Date(schedule.schedule_date).toLocaleDateString(),
            created: new Date(schedule.created_at).toLocaleDateString(),
          }))}
          actions={(row) => [
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
        onClose={() => setIsModalOpen(false)}
        title="Create New Schedule"
      >
        <Form
          onSubmit={handleSubmit}
          isLoading={isSubmitting}
          fields={[
            {
              name: 'area_id',
              label: 'Area',
              type: 'select',
              options: areas.map((area) => ({
                value: area.area_id,
                label: area.area_name,
              })),
              required: true,
            },
            {
              name: 'schedule_date',
              label: 'Schedule Date',
              type: 'date',
              required: true,
            },
          ]}
          submitLabel="Create Schedule"
        />
      </Modal>
    </div>
  );
};
