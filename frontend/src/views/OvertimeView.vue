<template>
    <div class="overtime-container">
        <div v-if="error" class="error-alert">{{ error }}</div>
        <div v-if="loading" class="loading-overlay">Loading...</div>
        <h1 class="page-title">Overtime Request</h1>
        <CContainer class="form-container">
            <EmployeeSelect :employees="activeEmployees" v-model:selected-employee="selectedEmployees"
                :employee-id="selectedEmployeeId" />


            <ProjectSelect :projects="projects" v-model:selected-project="selectedProjects" />

            <DateSelect v-model:selected-date="selectedDate" v-model:is-holiday="isHoliday" />

            <TimeSection v-model:time-start="timeStart" v-model:time-end="timeEnd" :total-hours="totalHours" />

            <BreakSection v-model:has-break="hasBreak" v-model:time-break-start="timeBreakStart"
                v-model:time-break-end="timeBreakEnd" :total-break-hours="totalBreakHours" />

            <ReasonSection v-model:reason="overtimeReason" v-model:detail="overtimeDetail" />

            <CRow class="justify-content-center gap-2">
                <ActionButton variant="primary" label="Submit Request" :loading="submitting"
                    loading-text="Submitting..." @click="submitOvertimeRequest" />
                <ActionButton variant="danger" label="Delete Request" :loading="deleting"
                    :disabled="!hasExistingRequest" loading-text="Deleting..." @click="deleteOvertimeRequest" />
            </CRow>
        </CContainer>
    </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useOvertimeForm } from '@/composables/overtime/useOvertimeForm'
import EmployeeSelect from '@/components/overtime/EmployeeSelect.vue'
import ProjectSelect from '@/components/overtime/ProjectSelect.vue'
import DateSelect from '@/components/overtime/DateSelect.vue'
import TimeSection from '@/components/overtime/TimeSection.vue'
import BreakSection from '@/components/overtime/BreakSection.vue'
import ReasonSection from '@/components/overtime/ReasonSection.vue'
import ActionButton from '@/components/overtime/ActionButton.vue'

const {
    activeEmployees,
    selectedEmployees,
    selectedEmployeeId,
    projects,
    selectedProjects,
    selectedDate,
    timeStart,
    timeEnd,
    totalHours,
    hasBreak,
    timeBreakStart,
    timeBreakEnd,
    totalBreakHours,
    overtimeReason,
    overtimeDetail,
    submitting,
    isHoliday,
    loadInitialData,
    submitOvertimeRequest,
    deleting,
    deleteOvertimeRequest,
    hasExistingRequest,
} = useOvertimeForm()

onMounted(async () => {
    await loadInitialData()
})

defineOptions({
    name: 'OvertimeView'
})
</script>

<style lang="scss">
@import '@/assets/styles/overtime.scss';
</style>