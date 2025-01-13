import { computed } from 'vue'
import { calculateTimeDifference } from '@/utils/timeCalculations'
import { timeToMinutes, minutesToTime } from './timeHelpers'

export function useOvertimeComputed(state) {
    const activeEmployees = computed(() =>
        state.employees.value.filter(employee => employee.is_enabled)
    )

    const selectedEmployeeId = computed(() => {
        const selectedEmployee = state.employees.value.find(
            employee => employee.id == state.selectedEmployees.value
        )
        return selectedEmployee ? selectedEmployee.emp_id : 'MW-------'
    })

    const totalHours = computed(() => {
        const rawHours = calculateTimeDifference(state.timeStart.value, state.timeEnd.value)
        if (state.hasBreak.value && state.timeBreakStart.value && state.timeBreakEnd.value) {
            const breakHours = calculateTimeDifference(state.timeBreakStart.value, state.timeBreakEnd.value)
            return (parseFloat(rawHours) - parseFloat(breakHours)).toFixed(2)
        }
        return rawHours
    })

    const totalBreakHours = computed(() =>
        state.hasBreak.value ?
            calculateTimeDifference(state.timeBreakStart.value, state.timeBreakEnd.value) :
            '0.00'
    )


    const defaultBreakStart = computed(() => {
        if (!state.timeStart.value || !state.timeEnd.value) return ''

        const startMinutes = timeToMinutes(state.timeStart.value)
        const endMinutes = timeToMinutes(state.timeEnd.value)
        const duration = endMinutes - startMinutes

        if (duration >= 240) {
            return minutesToTime(startMinutes + 240)
        } else {
            const middleMinutes = Math.floor((startMinutes + endMinutes) / 2)
            return minutesToTime(middleMinutes)
        }
    })

    const defaultBreakEnd = computed(() => {
        if (!defaultBreakStart.value) return ''

        const startMinutes = timeToMinutes(state.timeStart.value)
        const endMinutes = timeToMinutes(state.timeEnd.value)
        const duration = endMinutes - startMinutes

        if (duration >= 240) {
            const breakStartMinutes = timeToMinutes(defaultBreakStart.value)
            return minutesToTime(breakStartMinutes + 60)
        } else {
            const breakStartMinutes = timeToMinutes(defaultBreakStart.value)
            return minutesToTime(breakStartMinutes + 30)
        }
    })

    return {
        activeEmployees,
        selectedEmployeeId,
        totalHours,
        totalBreakHours,
        defaultBreakStart,
        defaultBreakEnd
    }
}