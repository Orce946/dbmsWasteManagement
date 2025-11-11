import React, { useContext } from 'react';
import { NotificationContext } from '../context/NotificationContext';

export const Notification = () => {
  const { notification } = useContext(NotificationContext) || { notification: null };

  if (!notification) return null;

  const bgColor = {
    success: 'bg-green-500',
    error: 'bg-red-500',
    warning: 'bg-yellow-500',
    info: 'bg-blue-500',
  }[notification.type];

  return (
    <div className={`fixed top-4 right-4 ${bgColor} text-white px-6 py-3 rounded-lg shadow-lg z-50`}>
      {notification.message}
    </div>
  );
};
