import { useOvertimeState } from './state'
import { useOvertimeComputed } from './computed'
import { useOvertimeValidation } from './validation'
import { useOvertimeApi } from './apiHandlers'
import { useOvertimeWatchers } from './watchers'

export function useOvertimeForm() {
    const state = useOvertimeState()
    const computed = useOvertimeComputed(state)
    const { validateForm } = useOvertimeValidation(state)
    const api = useOvertimeApi(state, computed)

    // Pass validateForm to api handlers
    const apiWithValidation = {
        ...api,
        submitOvertimeRequest: () => api.submitOvertimeRequest(
            validateForm,
            computed.totalHours.value,
            computed.totalBreakHours.value
        )
    }

    useOvertimeWatchers(state, computed, apiWithValidation)

    return {
        ...state,
        ...computed,
        loadInitialData: api.loadInitialData,
        submitOvertimeRequest: apiWithValidation.submitOvertimeRequest,
        checkExistingRequest: api.checkExistingRequest,
        deleteOvertimeRequest: api.deleteOvertimeRequest
    }
}