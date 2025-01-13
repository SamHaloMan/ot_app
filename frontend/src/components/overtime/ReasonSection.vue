<template>
    <CRow class="justify-content-center mb-3">
        <CCol md="8">
            <div class="reason-section">
                <CRow class="align-items-start mb-2">
                    <CCol md="12" class="text-start mb-1">
                        <label class="credentials">REASON</label>
                    </CCol>
                    <CCol md="12">
                        <CFormInput :model-value="reason" @update:model-value="$emit('update:reason', $event)"
                            placeholder="Please provide reason for overtime request" class="custom-input text-start" />
                    </CCol>
                </CRow>
                <CRow class="align-items-start">
                    <CCol md="12" class="text-start mb-1">
                        <label class="credentials">DETAILS</label>
                    </CCol>
                    <CCol md="12">
                        <CFormTextarea :model-value="detail" @update:model-value="$emit('update:detail', $event)"
                            placeholder="Please provide additional details for your overtime" class="custom-textarea"
                            style="min-height: 150px" rows="3" />
                    </CCol>
                </CRow>
            </div>
        </CCol>
    </CRow>
</template>

<script setup>
defineProps({
    reason: {
        type: String,
        default: ''
    },
    detail: {
        type: String,
        default: ''
    }
})
</script>