<template>
    <CButton :color="variant" class="submit-button" @click="$emit('click')" :disabled="loading || disabled">
        {{ loading ? loadingText : label }}
    </CButton>
</template>

<script setup>
defineProps({
    variant: {
        type: String,
        default: 'primary'
    },
    label: {
        type: String,
        required: true
    },
    loading: {
        type: Boolean,
        default: false
    },
    loadingText: {
        type: String,
        default: 'Loading...'
    },
    disabled: {
        type: Boolean,
        default: false
    }
})

defineEmits(['click'])
</script>