<template>
    <CContainer class="overtime-form">
        <EmployeeSelect :employees="activeEmployees" :selectedEmployee="selectedEmployees"
            :employeeId="selectedEmployeeId" @update:selectedEmployee="$emit('update:selectedEmployees', $event)" />

        <ProjectSelect :projects="projects" :selectedProject="selectedProjects"
            @update:selectedProject="$emit('update:selectedProjects', $event)" />

        <DateSelect v-model="selectedDate" :isHoliday="isHoliday"
            @update:modelValue="$emit('update:selectedDate', $event)"
            @update:isHoliday="$emit('update:isHoliday', $event)" />

        <TimeSection :timeStart="timeStart" :timeEnd="timeEnd" :totalHours="totalHours"
            @update:timeStart="$emit('update:timeStart', $event)" @update:timeEnd="$emit('update:timeEnd', $event)" />

        <BreakSection :hasBreak="hasBreak" :timeBreakStart="timeBreakStart" :timeBreakEnd="timeBreakEnd"
            :totalBreakHours="totalBreakHours" @update:hasBreak="$emit('update:hasBreak', $event)"
            @update:timeBreakStart="$emit('update:timeBreakStart', $event)"
            @update:timeBreakEnd="$emit('update:timeBreakEnd', $event)" />

        <ReasonSection :reason="overtimeReason" @update:reason="$emit('update:overtimeReason', $event)" />

        <CRow class="justify-content-center gap-3">
            <ActionButton variant="primary" label="Submit Request" :loading="submitting" loading-text="Submitting..."
                @click="submitOvertimeRequest" />
            <ActionButton variant="danger" label="Delete Request" :loading="deleting" :disabled="!hasExistingRequest"
                loading-text="Deleting..." @click="deleteOvertimeRequest" />
        </CRow>
    </CContainer>
</template>

<script setup>
import EmployeeSelect from './EmployeeSelect.vue'
import DateSelect from './DateSelect.vue'
import ProjectSelect from './ProjectSelect.vue'
import TimeSection from './TimeSection.vue'
import BreakSection from './BreakSection.vue'
import ReasonSection from './ReasonSection.vue'
import ActionButton from './ActionButton.vue'

defineProps({
    activeEmployees: Array,
    selectedEmployees: String,
    employeeId: String,
    projects: Array,
    selectedProjects: String,
    selectedDate: String,
    timeStart: String,
    timeEnd: String,
    totalHours: String,
    hasBreak: Boolean,
    timeBreakStart: String,
    timeBreakEnd: String,
    totalBreakHours: String,
    overtimeReason: String,
    submitting: Boolean,
    isHoliday: Boolean,
})
</script>