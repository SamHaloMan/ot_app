<template>
    <div>
        <h2>Employees List</h2>
        <div v-if="loading">Loading...</div>
        <div v-else-if="error">{{ error }}</div>
        <ul v-else>
            <li v-for="employee in employees" :key="employee.id">
                ID: {{ employee.id }} - {{ employee.name }} ({{ employee.is_enabled ? 'Enabled' : 'Disabled' }})
            </li>
        </ul>
    </div>
</template>

<script>
import api from '@/services/api'

export default {
    name: 'EmployeeList',
    data() {
        return {
            employees: [],
            loading: true,
            error: null
        }
    },
    async created() {
        try {
            const response = await api.getEmployees()
            this.employees = response.data
        } catch (error) {
            this.error = 'Failed to load employees'
            console.error('Error:', error)
        } finally {
            this.loading = false
        }
    }
}
</script>