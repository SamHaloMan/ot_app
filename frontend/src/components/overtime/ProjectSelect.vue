<template>
    <CRow class="justify-content-center mb-2">
        <CCol md="12">
            <CRow class="align-items-center ">
                <CCol md="1" class="text-start">
                    <label class="credentials">PROJECT</label>
                </CCol>
                <CCol md="11">
                    <CFormSelect class="text-center" :value="selectedProject"
                        @change="$emit('update:selectedProject', $event.target.value)">
                        <option value="">Select Project</option>
                        <option v-for="project in projects" :key="project.id" :value="project.id">
                            {{ project.name }}
                        </option>
                    </CFormSelect>
                </CCol>
            </CRow>
        </CCol>
    </CRow>
</template>

<script setup>
defineProps({
    projects: {
        type: Array,
        required: true
    },
    selectedProject: {
        type: String,
        default: ''
    }
})
</script>