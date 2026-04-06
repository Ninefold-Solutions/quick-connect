const SHORT_MONTH_FORMATTER = new Intl.DateTimeFormat("en-US", { month: "short" });

function cloneDate(date) {
    return new Date(date.getTime());
}

export function parseISO(input) {
    // Parse yyyy-MM-dd as a local date to avoid timezone shifts.
    if (/^\d{4}-\d{2}-\d{2}$/.test(input)) {
        const [year, month, day] = input.split("-").map(Number);
        return new Date(year, month - 1, day);
    }

    return new Date(input);
}

export function format(date, pattern) {
    if (pattern === "yyyy") {
        return String(date.getFullYear());
    }

    if (pattern === "yyyy-MM-dd") {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        return `${year}-${month}-${day}`;
    }

    if (pattern === "MMM") {
        return SHORT_MONTH_FORMATTER.format(date);
    }

    throw new Error(`Unsupported format pattern: ${pattern}`);
}

export function addWeeks(date, weeks) {
    const next = cloneDate(date);
    next.setDate(next.getDate() + weeks * 7);
    return next;
}

export function getMonth(date) {
    return date.getMonth();
}

export function isAfter(date, dateToCompare) {
    return date.getTime() > dateToCompare.getTime();
}

export function isBefore(date, dateToCompare) {
    return date.getTime() < dateToCompare.getTime();
}

export function startOfWeek(date) {
    const start = cloneDate(date);
    start.setHours(0, 0, 0, 0);
    start.setDate(start.getDate() - start.getDay());
    return start;
}

export function setDay(date, dayOfWeek) {
    const next = cloneDate(date);
    next.setDate(next.getDate() - next.getDay() + dayOfWeek);
    return next;
}
