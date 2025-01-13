<template>
    <div>
      <h2>Projects List</h2>
      <div v-if="loading">Loading...</div>
      <div v-else-if="error">{{ error }}</div>
      <ul v-else>
        <li v-for="project in projects" :key="project.id">
          ID: {{ project.id }} - {{ project.name }} ({{ project.is_enabled ? 'Enabled' : 'Disabled' }})
        </li>
      </ul>
    </div>
  </template>

<script>
import api from '@/services/api'

export default {
  name: 'ProjectList',
  data() {
    return {
      projects: [],
      loading: true,
      error: null
    }
  },
  async created() {
    try {
      const response = await api.getProjects()
      this.projects = response.data
    } catch (error) {
      this.error = 'Failed to load projects'
      console.error('Error:', error)
    } finally {
      this.loading = false
    }
  }
}
</script>