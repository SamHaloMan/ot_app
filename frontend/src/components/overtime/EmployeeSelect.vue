<template>
    <CRow class="justify-content-start mb-2">
        <CCol md="12">
            <CRow class="align-items-center">
                <CCol md="1" class="text-start">
                    <label class="credentials">NAME</label>
                </CCol>
                <CCol md="8">
                    <CFormSelect class="text-center" :value="selectedEmployee"
                        @change="$emit('update:selectedEmployee', $event.target.value)">
                        <option value="">Select Employees</option>
                        <option v-for="employee in employees" :key="employee.id" :value="employee.id">
                            {{ employee.name }}
                        </option>
                    </CFormSelect>
                </CCol>
                <CCol md="1" class="text-center">
                    <label class="credentials">ID</label>
                </CCol>
                <CCol md="2">
                    <label class="credentials text-start d-block">{{ employeeId }}</label>
                </CCol>
            </CRow>
        </CCol>
    </CRow>
</template>

<script setup>
defineProps({
    employees: {
        type: Array,
        required: true
    },
    selectedEmployee: {
        type: String,
        default: ''
    },
    employeeId: {
        type: String,
        default: 'MW-------'
    }
})
</script>