export const calculateTimeDifference = (startTime, endTime) => {
    if (!startTime || !endTime) return 0

    const [startHour, startMinute] = startTime.split(':').map(Number)
    const [endHour, endMinute] = endTime.split(':').map(Number)

    if (isNaN(startHour) || isNaN(startMinute) || isNaN(endHour) || isNaN(endMinute)) return 0

    const startTotalMinutes = startHour * 60 + startMinute
    const endTotalMinutes = endHour * 60 + endMinute

    const diffMinutes = endTotalMinutes - startTotalMinutes
    return diffMinutes <= 0 ? 0 : (diffMinutes / 60).toFixed(2)
}