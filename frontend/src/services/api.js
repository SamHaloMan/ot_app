import axios from 'axios'

const apiClient = axios.create({
    baseURL: process.env.VUE_APP_API_BASE_URL,
    headers: {
        'Content-Type': 'application/json'
    }
})

export default {
    getProjects() {
        return apiClient.get('api/projects')
    },

    getEmployees() {
        return apiClient.get('api/employees')
    },

    // Overtime request
    getAllOvertimeRequests() {
        return apiClient.get('/api/overtime-requests/')
    },

    getSingleOvertimeRequest(id) {
        return apiClient.get(`/api/overtime-requests/${id}/`)
    },

    createOvertimeRequest(overtimeData) {
        return apiClient.post('/api/overtime-requests/', overtimeData)
    },

    updateOvertimeRequest(id, overtimeData) {
        return apiClient.put(`/api/overtime-requests/${id}/`, overtimeData)
    },

    deleteOvertimeRequest(id) {
        if (!id) throw new Error('ID is required for deletion');
        return apiClient.delete(`/api/overtime-requests/${id}/`);
    },

    exportFiles(date) {
        return apiClient.post('/api/overtime-requests/export_files/', { date });
    },

    exportOvertimeJson(date) {
        console.log('Exporting JSON for date:', date);
        return apiClient.post('/api/overtime-requests/export_json/',
            { date: date.toString() }  // Ensure date is converted to string
        ).catch(error => {
            console.error('Export JSON error:', error.response?.data || error);
            throw error;
        });
    },

    async checkExistingOvertimeRequest(employeeId, date) {
        const params = new URLSearchParams();
        if (employeeId) params.append('employee', employeeId);
        if (date) params.append('request_date', date);

        return apiClient.get(`/api/overtime-requests/?${params.toString()}`);
    },

}