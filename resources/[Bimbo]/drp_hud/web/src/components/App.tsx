import React, {useEffect, useState} from 'react';
import './App.scss'
import {debugData} from "../utils/debugData";
import {fetchNui} from "../utils/fetchNui";
import {useNuiEvent} from "../hooks/useNuiEvent";
import { CSSTransition } from 'react-transition-group';
import Draggable, { DraggableEventHandler } from 'react-draggable';

// This will set the NUI to visible if we are
// developing in browser
debugData([ { action: 'setVisible', data: true } ])
debugData([ { action: 'setCarHud', data: true } ])
debugData([ { action: 'setCompass', data: true } ])
debugData([ { action: 'setLocation', data: 'I dont know' } ])

const App: React.FC = () => {
  
  const [visible, setVisible] = useState(false)
  useNuiEvent<boolean>('setVisible', setVisible)

  const [pauseMenu, setPauseMenu] = useState(false)

  const [carHud, setCarHud] = useState(false)

  const [compass, setCompass] = useState(false)
  const [location, setLocation] = useState('')

  const [vehicleData, setVehicleData] = useState({
    speed: 0,
    gear: 0,
    fuel: 0,
    rpm: 0,
    engineAlert: false,
    seatBelt: false,
    nitrous: 0,
    position: 'right',
    visible: true
  })

  useNuiEvent<boolean>('setPauseMenu', setPauseMenu)
  useNuiEvent<boolean>('setCarHud', setCarHud)
  useNuiEvent<boolean>('setCompass', setCompass)
  useNuiEvent<string>('setLocation', setLocation)

  useNuiEvent<any>('setVehicleData', setVehicleData) 

  const [statusData, setStatusData] = useState({
    health: 50,
    armor: 50,
    weapon: "",
    maxAmmo: 0,
    clipAmmo: 0,
    rightX: 15,
    bottomY: 97
  })

  useNuiEvent<any>('setStatusData', setStatusData) 

  const [hudPosition, setHudPosition] = useState({ x: 0, y: 0 })

  const handleHudDrag = (_mouse: any, data: any) => {
    setHudPosition({ x: data.x, y: data.y })
  }

  useNuiEvent<any>('setHudPosition', setHudPosition) 

  useEffect(() => {

    const storedHudPosition = localStorage.getItem('hudPosition')
    if (!storedHudPosition) {
      return
    }

    setHudPosition(JSON.parse(storedHudPosition))
    
  }, [])

  const [movingHud, setMovingHud] = useState(false)
  useNuiEvent<boolean>('setMovingHud', setMovingHud)

  useEffect(() => {

    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) {
        fetchNui('stopMovingHud')
      }
    }

    window.addEventListener("keydown", keyHandler)
    return () => window.removeEventListener("keydown", keyHandler)

  }, [movingHud])

  useEffect(() => {

    localStorage.setItem('hudPosition', JSON.stringify(hudPosition));

  }, [hudPosition])

  // const getLeftOffset = () => {

  //   const hasWeapon = statusData.weapon !== ''
  //   if (!hasWeapon && !carHud) { // No weapon and no car hud
  //     return `${statusData.rightX * -0.4 }vh`
  //   }

  //   if (hasWeapon && !carHud) { // Weapon but no car hud
  //     return `${statusData.rightX * 0.07 }vh`
  //   }

  //   if (hasWeapon && carHud) { // Weapon and car hud
  //     return `${statusData.rightX * 1.9 }vh`
  //   }

  //   return `${statusData.rightX * 1.4 }vh` // No weapon and car hud

  // }

  // const getBottomOffset = () => {

  //   const hasWeapon = statusData.weapon !== ''
  //   if (!hasWeapon && !carHud) { // No weapon and no car hud
  //     return '-0.1vh'
  //   }

  //   if (hasWeapon && !carHud) { // Weapon but no car hud
  //     return `-1.7vh`
  //   }

  //   if (hasWeapon && carHud) { // Weapon and car hud
  //     return `${statusData.bottomY * -0.03 }vh`
  //   }

  //   return `${statusData.bottomY * -0.01 }vh` // No weapon and car hud

  // }

  // const [compassSize, setCompassSize] = useState<number>(18)
  // useNuiEvent<any>('setCompassSize', setCompassSize) 

  // useEffect(() => {

  //   const storedCompassSize = localStorage.getItem('compassSize')
  //   if (!storedCompassSize) {
  //     return
  //   }

  //   setCompassSize(JSON.parse(storedCompassSize))
    
  // }, [])

  // useEffect(() => {

  //   localStorage.setItem('compassSize', JSON.stringify(compassSize));

  // }, [compassSize])
  
  return (
    
      <div style={{ display: visible ? pauseMenu ? 'none' : '' : 'none' }} >

        <Draggable
          position={hudPosition}
          onDrag={handleHudDrag}
          grid={[10, 10]}
        >
          <div className='hudContainer' style={{ left: '0.1%', bottom: '0px' }} >
            
            <CSSTransition className="hexGroup" in={statusData.weapon !== ''} timeout={200} classNames="fadeWee" unmountOnExit enter>
              <div style={{ left: '0px', bottom: '40px' }}>
                <svg className='hex' width="32" height="36" viewBox="0 0 32 36" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M14.5 0.866026C15.4282 0.330127 16.5718 0.330127 17.5 0.866025L30.0885 8.13398C31.0167 8.66987 31.5885 9.66025 31.5885 10.7321V25.268C31.5885 26.3397 31.0167 27.3301 30.0885 27.866L17.5 35.134C16.5718 35.6699 15.4282 35.6699 14.5 35.134L1.91154 27.866C0.983339 27.3301 0.411543 26.3397 0.411543 25.268V10.732C0.411543 9.66025 0.98334 8.66987 1.91154 8.13398L14.5 0.866026Z" fill="url(#paint0_radial_1022_1541)"/>
                  <path d="M14.75 1.29904C15.5235 0.852456 16.4765 0.852456 17.25 1.29904L29.8385 8.56699C30.612 9.01357 31.0885 9.83889 31.0885 10.7321V25.268C31.0885 26.1611 30.612 26.9864 29.8385 27.433L17.25 34.701C16.4765 35.1475 15.5235 35.1475 14.75 34.701L2.16154 27.433C1.38804 26.9864 0.911543 26.1611 0.911543 25.268V10.732C0.911543 9.83889 1.38804 9.01357 2.16154 8.56699L14.75 1.29904Z" stroke="black" strokeOpacity="0.6"/>
                    <defs>
                      <radialGradient id="paint0_radial_1022_1541" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(16 18) rotate(90) scale(18)">
                        <stop stopColor="#2B3962" stopOpacity="0.6"/>
                        <stop offset="1" stopColor="#908aff" stopOpacity="0.7"/>
                      </radialGradient>
                    </defs>
                </svg>
                <div className='divWorkaround' style={{ bottom: '13px' }} >{statusData.clipAmmo}</div>
              </div>
            </CSSTransition>

            <CSSTransition className="hexGroup" in={statusData.weapon !== ''} timeout={200} classNames="fadeWee" unmountOnExit enter>
              <div style={{ left: '20px', bottom: '6px' }} >

                <svg className='hex' width="32" height="36" viewBox="0 0 32 36" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M14.5 0.866026C15.4282 0.330127 16.5718 0.330127 17.5 0.866025L30.0885 8.13398C31.0167 8.66987 31.5885 9.66025 31.5885 10.7321V25.268C31.5885 26.3397 31.0167 27.3301 30.0885 27.866L17.5 35.134C16.5718 35.6699 15.4282 35.6699 14.5 35.134L1.91154 27.866C0.983339 27.3301 0.411543 26.3397 0.411543 25.268V10.732C0.411543 9.66025 0.98334 8.66987 1.91154 8.13398L14.5 0.866026Z" fill="url(#paint0_radial_1022_1111)"/>
                  <path d="M14.75 1.29904C15.5235 0.852456 16.4765 0.852456 17.25 1.29904L29.8385 8.56699C30.612 9.01357 31.0885 9.83889 31.0885 10.7321V25.268C31.0885 26.1611 30.612 26.9864 29.8385 27.433L17.25 34.701C16.4765 35.1475 15.5235 35.1475 14.75 34.701L2.16154 27.433C1.38804 26.9864 0.911543 26.1611 0.911543 25.268V10.732C0.911543 9.83889 1.38804 9.01357 2.16154 8.56699L14.75 1.29904Z" stroke="black" strokeOpacity="0.6"/>
                  <defs>
                    <radialGradient id="paint0_radial_1022_1111" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(16 18) rotate(90) scale(18)">
                      <stop stopColor="#2B3962" stopOpacity="0.6"/>
                      <stop offset="1" stopColor="#908aff" stopOpacity="0.7"/>
                    </radialGradient>
                  </defs>
                </svg>
                <div className='divWorkaround' style={{ bottom: '13px' }} >{statusData.maxAmmo}</div>

              </div>
            </CSSTransition>
            
            <CSSTransition className="hexGroup" in={statusData.weapon !== ''} timeout={200} classNames="fadeWee" unmountOnExit enter>
              <div style={{ left: '40px', bottom: '30px' }} >

                <svg className='hex' width="70" height="80" viewBox="0 0 70 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M33.5 0.866026C34.4282 0.330127 35.5718 0.330127 36.5 0.866025L68.141 19.134C69.0692 19.6699 69.641 20.6603 69.641 21.7321V58.2679C69.641 59.3397 69.0692 60.3301 68.141 60.866L36.5 79.134C35.5718 79.6699 34.4282 79.6699 33.5 79.134L1.85898 60.866C0.930779 60.3301 0.358982 59.3397 0.358982 58.2679V21.7321C0.358982 20.6603 0.930779 19.6699 1.85898 19.134L33.5 0.866026Z" fill="url(#paint0_radial_1022_1539)"/>
                  <path d="M34.125 1.94856C34.6665 1.63595 35.3335 1.63595 35.875 1.94856L67.516 20.2165C68.0575 20.5291 68.391 21.1068 68.391 21.7321V58.2679C68.391 58.8932 68.0575 59.4709 67.516 59.7835L35.875 78.0514C35.3335 78.3641 34.6665 78.3641 34.125 78.0514L2.48398 59.7835C1.94253 59.4709 1.60898 58.8932 1.60898 58.2679V21.7321C1.60898 21.1068 1.94253 20.5291 2.48398 20.2165L34.125 1.94856Z" stroke="black" strokeOpacity="0.6" strokeWidth="2.5"/>
                  <defs>
                    <radialGradient id="paint0_radial_1022_1539" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(35 40) rotate(90) scale(40)">
                      <stop stopColor="#2B3962" stopOpacity="0.6"/>
                      <stop offset="1" stopColor="#908aff" stopOpacity="0.7"/>
                    </radialGradient>
                  </defs>
                </svg>

                <img src={require(`./images/${statusData.weapon || 'empty.png'}`)} alt='' style={{ bottom: '20px', left: '10px', width: '50px', height: '50px' }} ></img>

              </div>
            </CSSTransition>

            <div className='hexGroup' style={{ left: '118px', bottom: '59px' }}>
              
              <svg className='healthshadow' width="185" height="39" viewBox="0 0 185 39" fill="none" xmlns="http://www.w3.org/2000/svg">
                <mask id="path-1-inside-1_1022_1509" fill="white">
                <path fillRule="evenodd" clipRule="evenodd" d="M19.3205 0.535898C18.0829 -0.178633 16.5581 -0.178633 15.3205 0.535898L2 8.2265C0.762398 8.94103 0 10.2615 0 11.6906V27.0718C0 28.5009 0.762398 29.8214 2 30.5359L15.3205 38.2265C16.5581 38.941 18.0829 38.941 19.3205 38.2265L32.641 30.5359C33.8786 29.8214 34.641 28.5009 34.641 27.0718V27.0718C34.641 25.5867 35.8449 24.3828 37.33 24.3828H179.32C182.082 24.3828 184.32 22.1443 184.32 19.3828C184.32 16.6214 182.082 14.3828 179.32 14.3828H37.3333C35.8464 14.3828 34.641 13.1775 34.641 11.6906V11.6906C34.641 10.2615 33.8786 8.94103 32.641 8.2265L19.3205 0.535898Z"/>
                </mask>
                <path fillRule="evenodd" clipRule="evenodd" d="M19.3205 0.535898C18.0829 -0.178633 16.5581 -0.178633 15.3205 0.535898L2 8.2265C0.762398 8.94103 0 10.2615 0 11.6906V27.0718C0 28.5009 0.762398 29.8214 2 30.5359L15.3205 38.2265C16.5581 38.941 18.0829 38.941 19.3205 38.2265L32.641 30.5359C33.8786 29.8214 34.641 28.5009 34.641 27.0718V27.0718C34.641 25.5867 35.8449 24.3828 37.33 24.3828H179.32C182.082 24.3828 184.32 22.1443 184.32 19.3828C184.32 16.6214 182.082 14.3828 179.32 14.3828H37.3333C35.8464 14.3828 34.641 13.1775 34.641 11.6906V11.6906C34.641 10.2615 33.8786 8.94103 32.641 8.2265L19.3205 0.535898Z" fill="url(#paint0_radial_1022_1509)"/>
                <path d="M15.3205 0.535898L14.0705 -1.62917L14.0705 -1.62917L15.3205 0.535898ZM19.3205 0.535898L20.5705 -1.62917L20.5705 -1.62917L19.3205 0.535898ZM2 8.2265L0.75 6.06143L0.749999 6.06143L2 8.2265ZM2 30.5359L0.749999 32.701L0.75 32.701L2 30.5359ZM15.3205 38.2265L16.5705 36.0614L16.5705 36.0614L15.3205 38.2265ZM19.3205 38.2265L18.0705 36.0614L18.0705 36.0614L19.3205 38.2265ZM32.641 30.5359L33.891 32.701L33.891 32.701L32.641 30.5359ZM32.641 8.2265L31.391 10.3916L31.391 10.3916L32.641 8.2265ZM16.5705 2.70096C17.0346 2.43301 17.6064 2.43301 18.0705 2.70096L20.5705 -1.62917C18.5594 -2.79028 16.0816 -2.79028 14.0705 -1.62917L16.5705 2.70096ZM3.25 10.3916L16.5705 2.70096L14.0705 -1.62917L0.75 6.06143L3.25 10.3916ZM2.5 11.6906C2.5 11.1547 2.7859 10.6595 3.25 10.3916L0.749999 6.06143C-1.2611 7.22255 -2.5 9.36837 -2.5 11.6906H2.5ZM2.5 27.0718V11.6906H-2.5V27.0718H2.5ZM3.25 28.3708C2.7859 28.1029 2.5 27.6077 2.5 27.0718H-2.5C-2.5 29.394 -1.2611 31.5398 0.749999 32.701L3.25 28.3708ZM16.5705 36.0614L3.25 28.3708L0.75 32.701L14.0705 40.3916L16.5705 36.0614ZM18.0705 36.0614C17.6064 36.3294 17.0346 36.3294 16.5705 36.0614L14.0705 40.3916C16.0816 41.5527 18.5594 41.5527 20.5705 40.3916L18.0705 36.0614ZM31.391 28.3708L18.0705 36.0614L20.5705 40.3916L33.891 32.701L31.391 28.3708ZM32.141 27.0718C32.141 27.6077 31.8551 28.1029 31.391 28.3708L33.891 32.701C35.9021 31.5398 37.141 29.394 37.141 27.0718H32.141ZM179.32 21.8828H37.33V26.8828H179.32V21.8828ZM181.82 19.3828C181.82 20.7635 180.701 21.8828 179.32 21.8828V26.8828C183.462 26.8828 186.82 23.525 186.82 19.3828H181.82ZM179.32 16.8828C180.701 16.8828 181.82 18.0021 181.82 19.3828H186.82C186.82 15.2407 183.462 11.8828 179.32 11.8828V16.8828ZM37.3333 16.8828H179.32V11.8828H37.3333V16.8828ZM31.391 10.3916C31.8551 10.6595 32.141 11.1547 32.141 11.6906H37.141C37.141 9.36837 35.9021 7.22255 33.891 6.06143L31.391 10.3916ZM18.0705 2.70096L31.391 10.3916L33.891 6.06143L20.5705 -1.62917L18.0705 2.70096ZM37.3333 11.8828C37.2271 11.8828 37.141 11.7968 37.141 11.6906H32.141C32.141 14.5582 34.4657 16.8828 37.3333 16.8828V11.8828ZM37.141 27.0718C37.141 26.9674 37.2256 26.8828 37.33 26.8828V21.8828C34.4642 21.8828 32.141 24.206 32.141 27.0718H37.141Z" fill="black" fillOpacity="0.3" mask="url(#path-1-inside-1_1022_1509)"/>
                <defs>
                <radialGradient id="paint0_radial_1022_1509" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(92.1602 19.3812) rotate(90) scale(19.3812 92.1602)">
                  <stop stopColor="#2B3962" stopOpacity="0.6"/>
                  <stop offset="1" stopColor="#908aff" stopOpacity="0.7"/>
                </radialGradient>
                </defs>
              </svg>

              <div style={{ display: 'flex', bottom: '13px', position: 'absolute' }} >

                <svg className='healthiconshadow' style={{ marginLeft: '-1.5px', marginBottom: '-2px' }} width="70" height="23" viewBox="0 0 52 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path fillRule="evenodd" clipRule="evenodd" d="M11.4821 7.7409l-.9122.8418-.896-.8624c-.1951-.1874-.4716-.2907-.7791-.2907-.3256 0-.6156.1176-.8172.3307-.4677.4987-.4651 1.2946.0071 1.8114l2.5046 2.761 2.4936-2.7546c.4761-.5213.4774-1.3224.0052-1.8256C12.6863 7.343 11.9512 7.3087 11.4821 7.7409zM15.3633.5089c-1.4761 0-2.8457.542-3.9613 1.5679l-.823.761-.8127-.781c-1.022-.9852-2.4258-1.5278-3.9523-1.5278-1.6241 0-3.0957.6137-4.1454 1.7294-2.2223 2.3657-2.2248 6.1216-.0077 8.5493l8.9382 9.8516 8.9071-9.84c2.2235-2.4348 2.2165-6.2036-.0258-8.5913C18.3931 1.1194 16.9312.5089 15.3633.5089zM14.0616 10.4684l-3.471 3.8347-3.4839-3.8405c-.9341-1.0226-.9315-2.6079.0071-3.6086.4548-.4826 1.0866-.7474 1.781-.7474.6499 0 1.252.2338 1.6945.6583.98-.8993 2.5485-.8508 3.4529.0432C14.9951 7.8514 14.9996 9.4418 14.0616 10.4684z" fill="#ffffff"/>
                  <path d="M11.4821 7.7409l-.9122.8418-.896-.8624c-.1951-.1874-.4716-.2907-.7791-.2907-.3256 0-.6156.1176-.8172.3307-.4677.4987-.4651 1.2946.0071 1.8114l2.5046 2.761 2.4936-2.7546c.4761-.5213.4774-1.3224.0052-1.8256C12.6863 7.343 11.9512 7.3087 11.4821 7.7409zM15.3633.5089c-1.4761 0-2.8457.542-3.9613 1.5679l-.823.761-.8127-.781c-1.022-.9852-2.4258-1.5278-3.9523-1.5278-1.6241 0-3.0957.6137-4.1454 1.7294-2.2223 2.3657-2.2248 6.1216-.0077 8.5493l8.9382 9.8516 8.9071-9.84c2.2235-2.4348 2.2165-6.2036-.0258-8.5913C18.3931 1.1194 16.9312.5089 15.3633.5089zM14.0616 10.4684l-3.471 3.8347-3.4839-3.8405c-.9341-1.0226-.9315-2.6079.0071-3.6086.4548-.4826 1.0866-.7474 1.781-.7474.6499 0 1.252.2338 1.6945.6583.98-.8993 2.5485-.8508 3.4529.0432C14.9951 7.8514 14.9996 9.4418 14.0616 10.4684z" stroke="black" strokeOpacity="0.3"/>
                </svg>

                <div style={{ position: 'absolute', bottom: '9px', width: '142px', left: '56px' }} >
                  <div className='progressBar' style={{ background: '#ffffff', width: `${statusData.health}%` }} ></div>
                </div>
                

              </div>
              

            </div>

            <div className='hexGroup' style={{ left: '138px', bottom: '28px' }}>
              <svg className='armorshadow' width="185" height="39" viewBox="0 0 185 39" fill="none" xmlns="http://www.w3.org/2000/svg">
                <mask id="path-1-inside-1_1022_1509" fill="white">
                <path fillRule="evenodd" clipRule="evenodd" d="M19.3205 0.535898C18.0829 -0.178633 16.5581 -0.178633 15.3205 0.535898L2 8.2265C0.762398 8.94103 0 10.2615 0 11.6906V27.0718C0 28.5009 0.762398 29.8214 2 30.5359L15.3205 38.2265C16.5581 38.941 18.0829 38.941 19.3205 38.2265L32.641 30.5359C33.8786 29.8214 34.641 28.5009 34.641 27.0718V27.0718C34.641 25.5867 35.8449 24.3828 37.33 24.3828H179.32C182.082 24.3828 184.32 22.1443 184.32 19.3828C184.32 16.6214 182.082 14.3828 179.32 14.3828H37.3333C35.8464 14.3828 34.641 13.1775 34.641 11.6906V11.6906C34.641 10.2615 33.8786 8.94103 32.641 8.2265L19.3205 0.535898Z"/>
                </mask>
                <path fillRule="evenodd" clipRule="evenodd" d="M19.3205 0.535898C18.0829 -0.178633 16.5581 -0.178633 15.3205 0.535898L2 8.2265C0.762398 8.94103 0 10.2615 0 11.6906V27.0718C0 28.5009 0.762398 29.8214 2 30.5359L15.3205 38.2265C16.5581 38.941 18.0829 38.941 19.3205 38.2265L32.641 30.5359C33.8786 29.8214 34.641 28.5009 34.641 27.0718V27.0718C34.641 25.5867 35.8449 24.3828 37.33 24.3828H179.32C182.082 24.3828 184.32 22.1443 184.32 19.3828C184.32 16.6214 182.082 14.3828 179.32 14.3828H37.3333C35.8464 14.3828 34.641 13.1775 34.641 11.6906V11.6906C34.641 10.2615 33.8786 8.94103 32.641 8.2265L19.3205 0.535898Z" fill="url(#paint0_radial_1022_1509)"/>
                <path d="M15.3205 0.535898L14.0705 -1.62917L14.0705 -1.62917L15.3205 0.535898ZM19.3205 0.535898L20.5705 -1.62917L20.5705 -1.62917L19.3205 0.535898ZM2 8.2265L0.75 6.06143L0.749999 6.06143L2 8.2265ZM2 30.5359L0.749999 32.701L0.75 32.701L2 30.5359ZM15.3205 38.2265L16.5705 36.0614L16.5705 36.0614L15.3205 38.2265ZM19.3205 38.2265L18.0705 36.0614L18.0705 36.0614L19.3205 38.2265ZM32.641 30.5359L33.891 32.701L33.891 32.701L32.641 30.5359ZM32.641 8.2265L31.391 10.3916L31.391 10.3916L32.641 8.2265ZM16.5705 2.70096C17.0346 2.43301 17.6064 2.43301 18.0705 2.70096L20.5705 -1.62917C18.5594 -2.79028 16.0816 -2.79028 14.0705 -1.62917L16.5705 2.70096ZM3.25 10.3916L16.5705 2.70096L14.0705 -1.62917L0.75 6.06143L3.25 10.3916ZM2.5 11.6906C2.5 11.1547 2.7859 10.6595 3.25 10.3916L0.749999 6.06143C-1.2611 7.22255 -2.5 9.36837 -2.5 11.6906H2.5ZM2.5 27.0718V11.6906H-2.5V27.0718H2.5ZM3.25 28.3708C2.7859 28.1029 2.5 27.6077 2.5 27.0718H-2.5C-2.5 29.394 -1.2611 31.5398 0.749999 32.701L3.25 28.3708ZM16.5705 36.0614L3.25 28.3708L0.75 32.701L14.0705 40.3916L16.5705 36.0614ZM18.0705 36.0614C17.6064 36.3294 17.0346 36.3294 16.5705 36.0614L14.0705 40.3916C16.0816 41.5527 18.5594 41.5527 20.5705 40.3916L18.0705 36.0614ZM31.391 28.3708L18.0705 36.0614L20.5705 40.3916L33.891 32.701L31.391 28.3708ZM32.141 27.0718C32.141 27.6077 31.8551 28.1029 31.391 28.3708L33.891 32.701C35.9021 31.5398 37.141 29.394 37.141 27.0718H32.141ZM179.32 21.8828H37.33V26.8828H179.32V21.8828ZM181.82 19.3828C181.82 20.7635 180.701 21.8828 179.32 21.8828V26.8828C183.462 26.8828 186.82 23.525 186.82 19.3828H181.82ZM179.32 16.8828C180.701 16.8828 181.82 18.0021 181.82 19.3828H186.82C186.82 15.2407 183.462 11.8828 179.32 11.8828V16.8828ZM37.3333 16.8828H179.32V11.8828H37.3333V16.8828ZM31.391 10.3916C31.8551 10.6595 32.141 11.1547 32.141 11.6906H37.141C37.141 9.36837 35.9021 7.22255 33.891 6.06143L31.391 10.3916ZM18.0705 2.70096L31.391 10.3916L33.891 6.06143L20.5705 -1.62917L18.0705 2.70096ZM37.3333 11.8828C37.2271 11.8828 37.141 11.7968 37.141 11.6906H32.141C32.141 14.5582 34.4657 16.8828 37.3333 16.8828V11.8828ZM37.141 27.0718C37.141 26.9674 37.2256 26.8828 37.33 26.8828V21.8828C34.4642 21.8828 32.141 24.206 32.141 27.0718H37.141Z" fill="black" fillOpacity="0.3" mask="url(#path-1-inside-1_1022_1509)"/>
                <defs>
                <radialGradient id="paint0_radial_1022_1509" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(92.1602 19.3812) rotate(90) scale(19.3812 92.1602)">
                <stop stopColor="#2B3962" stopOpacity="0.6"/>
                <stop offset="1" stopColor="#908aff" stopOpacity="0.7"/>
                </radialGradient>
                </defs>
              </svg>

              <div style={{ display: 'flex', bottom: '13px', position: 'absolute' }} >

                <svg className='armoriconshadow' style={{ marginLeft: '1px' }} width="60" height="22" viewBox="0 0 39 19.5" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M14.9091 4.99277C14.9091 12.9227 9.49324 17 7.92847 17C6.47381 17 1 13.0475 1 4.99277C1 4.38726 1.33903 3.84196 1.85802 3.61142L7.39557 1.11546C7.53774 1.0521 7.77605 1 7.92992 1C8.08294 1 8.32343 1.0521 8.46484 1.11546L14.0285 3.61142C14.5701 3.86972 14.9091 4.41565 14.9091 4.99277Z" fill="#41217d"/>
                  <path d="M7.19204 0.658758L7.19203 0.658754L7.19011 0.65962L1.6537 3.15507C0.940272 3.47266 0.5 4.20663 0.5 4.99277C0.5 9.13966 1.91081 12.2479 3.52393 14.3237C4.32888 15.3595 5.18625 16.1411 5.94779 16.6678C6.32831 16.931 6.6907 17.1345 7.01616 17.274C7.33244 17.4096 7.6492 17.5 7.92847 17.5C8.21945 17.5 8.54628 17.4089 8.87376 17.2693C9.2091 17.1263 9.5789 16.9179 9.96481 16.6495C10.7371 16.1124 11.5974 15.3187 12.4016 14.2753C14.0128 12.1848 15.4091 9.07727 15.4091 4.99277C15.4091 4.22186 14.9583 3.50095 14.2437 3.16012L14.2438 3.16L14.2331 3.15523L8.6695 0.65926L8.66928 0.659162C8.46494 0.567607 8.1549 0.5 7.92992 0.5C7.70327 0.5 7.39579 0.567949 7.19204 0.658758Z" stroke="black" strokeOpacity="0.45"/>
                </svg>

                <div style={{ position: 'absolute', bottom: '9px', width: '142px', left: '56px' }} >
                  <div className='progressBar' style={{ background: '#41217d', width: `${statusData.armor}%` }} ></div>
                </div>

              </div>
              

            </div>


          </div>

        </Draggable>

      </div>

    
    
  );
}

export default App;
