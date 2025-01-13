<template>
    <CRow class="justify-content-center mb-2">
        <CCol xs="12" md="10">
            <div class="time-section">
                <CRow>
                    <CCol xs="4">
                        <div class="time-block">
                            <label class="form-label">Start of OT Hour</label>
                            <div class="time-picker">
                                <VueDatePicker :model-value="timeStart"
                                    @update:model-value="$emit('update:timeStart', $event)" time-picker
                                    model-type="HH:mm" :enable-seconds="false" :is-24="true" placeholder="Select Time">
                                    <template #input-icon>
                                        <div class="icon-wrapper">
                                            <img class="datepicker-icon" src="@/assets/clock.png" />
                                        </div>
                                    </template>
                                </VueDatePicker>
                            </div>
                        </div>
                    </CCol>
                    <CCol xs="4">
                        <div class="hours-display">
                            <label class="OT_hours">{{ totalHours }} Hours</label>
                        </div>
                    </CCol>
                    <CCol xs="4">
                        <div class="time-block">
                            <label class="form-label">End of OT Hour</label>
                            <div class="time-picker">
                                <VueDatePicker :model-value="timeEnd"
                                    @update:model-value="$emit('update:timeEnd', $event)" time-picker model-type="HH:mm"
                                    :enable-seconds="false" :is-24="true" placeholder="Select Time">
                                    <template #input-icon>
                                        <div class="icon-wrapper">
                                            <img class="datepicker-icon" src="@/assets/clock.png" />
                                        </div>
                                    </template>
                                </VueDatePicker>
                            </div>
                        </div>
                    </CCol>
                </CRow>
            </div>
        </CCol>
    </CRow>
</template>

<script setup>
import VueDatePicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

defineProps({
    timeStart: {
        type: String,
        required: true
    },
    timeEnd: {
        type: String,
        required: true
    },
    totalHours: {
        type: String,
        default: '0.00'
    }
})
</script>