import {FC, useState} from 'react';
import './App.scss'
import {debugData} from "../utils/debugData";
import {useNuiEvent} from "../hooks/useNuiEvent";

debugData([ { action: 'setVisible', data: 1 } ])

const App: FC = () => {

  const [pressText, setPressText] = useState("")
  const [text, setText] = useState("")

  const [visible, setVisible] = useState(0)

  useNuiEvent<number>('setVisible', (data) => { setVisible(data) })
  useNuiEvent<string>('setText', (data) => { setText(data) })
  useNuiEvent<string>('setPressText', (data) => { setPressText(data) })

  return (
    <div className="nui-wrapper"  >
      <section className={`mainContainer state${visible}`}>
        <span className="top">{pressText}</span>
        <span className="bottom">{text}</span>
      </section>
    </div>
  );

}

export default App;
