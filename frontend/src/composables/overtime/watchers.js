import { watch } from 'vue'
import { timeToMinutes } from './timeHelpers'

export function useOvertimeWatchers(state, computed, api) {
    watch([state.selectedEmployees, state.selectedDate], async ([newEmployee, newDate]) => {
        if (newEmployee && newDate) {
            await api.checkExistingRequest(newEmployee, newDate)
        }
    })

    watch([state.timeStart, state.timeEnd], ([newStart, newEnd]) => {
        if (!newStart || !newEnd) return

        const startMinutes = timeToMinutes(newStart)
        const endMinutes = timeToMinutes(newEnd)
        const duration = endMinutes - startMinutes

        if (duration >= 240) {
            state.hasBreak.value = true
            state.timeBreakStart.value = computed.defaultBreakStart.value
            state.timeBreakEnd.value = computed.defaultBreakEnd.value
        }
    })

    watch(state.hasBreak, (newValue) => {
        if (newValue) {
            state.timeBreakStart.value = computed.defaultBreakStart.value
            state.timeBreakEnd.value = computed.defaultBreakEnd.value
        } else {
            state.timeBreakStart.value = ''
            state.timeBreakEnd.value = ''
        }
    })
}