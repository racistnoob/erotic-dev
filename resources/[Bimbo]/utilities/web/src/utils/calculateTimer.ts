import { useEffect } from "react"

const calculateTimer = (msec: number) => {
    const duracionTotal = msec;
    const porcentajeRestante = ((duracionTotal - msec) / duracionTotal) * 100;
    return porcentajeRestante;
}

export default calculateTimer 