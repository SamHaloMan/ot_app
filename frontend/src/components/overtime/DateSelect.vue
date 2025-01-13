<template>
    <CRow class="justify-content-center mb-2">
        <CCol md="12">
            <CRow class="align-items-center">
                <CCol md="1" class="text-start">
                    <label class="credentials">DATE</label>
                </CCol>
                <CCol md="8">
                    <input type="date" class="form-control text-center" :value="selectedDate"
                        @input="$emit('update:selectedDate', $event.target.value)" />
                </CCol>
                <CCol md="1">
                    <CFormCheck :model-value="isHoliday" @update:model-value="$emit('update:isHoliday', $event)"
                        id="holidayCheck" class="custom-checkbox" />
                </CCol>
                <CCol md="2">
                    <label class="credentials text-start d-block">Holiday</label>
                </CCol>
            </CRow>
        </CCol>
    </CRow>
</template>

<script setup>
defineProps({
    selectedDate: {
        type: String,
        required: true
    },
    isHoliday: {
        type: Boolean,
        default: false
    }
})
</script>

<style scoped>
input[type="date"] {
    padding: 0.375rem 0.75rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
}

input[type="date"]::-webkit-calendar-picker-indicator {
    cursor: pointer;
}
</style>