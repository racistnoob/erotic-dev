import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';
import { useNuiEvent } from '../hooks/useNuiEvent';

debugData([
  {
    action: 'setVisible',
    data: true,
  },
]);

interface Lobby {
  id: number;
  name: string;
  settings: string[]; // Array of strings for lobby settings
}

interface PlayerCountData {
  worldID: number; // or string, depending on your data
  count: number;
}

const App: React.FC = () => {

  const [lobbies] = useState<Lobby[]>([
    {
      id: 1,
      name: 'Southside #1',
      settings: ['FPS Mode', 'Light Recoil'],
    },
    
    {
      id: 2,
      name: 'Southside #2',
      settings: ['FPS Mode', 'Light Recoil'],

    },
    {
      id: 3,
      name: 'Southside #3',
      settings: ['FPS Mode', 'Light Recoil', 'Headshots'],
    },
    {
      id: 4,
      name: 'Southside #4',
      settings: ['FPS Mode', 'Light Recoil', 'Headshots'],
    },
    {
      id: 5,
      name: 'Southside #5',
      settings: ['FPS Mode', 'Medium Recoil'],
    },
    {
      id: 6,
      name: 'Southside #6',
      settings: ['FPS Mode', 'Medium Recoil'],
    },
    {
      id: 7,
      name: 'Southside #7',
      settings: ['FPS Mode', 'Medium Recoil', 'Headshots'],
    },
    {
      id: 8,
      name: 'Southside #8',
      settings: ['FPS Mode', 'Medium Recoil', 'Headshots'],
    },
    {
      id: 9,
      name: 'Southside #9',
      settings: ['FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'],
    },
    {
      id: 10,
      name: 'Southside #10',
      settings: ['FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'],
    },
    {
      id: 11,
      name: 'Southside #11',
      settings: ['FPS Mode', 'Medium Recoil'],
    },
    {
      id: 12,
      name: 'Southside #12',
      settings: ['FPS Mode', 'Medium Recoil'],
    },
    {
      id: 13,
      name: 'Southside #13',
      settings: ['FPS Mode', 'Heavy Recoil'],
    },
    {
      id: 14,
      name: 'Southside #14',
      settings: ['FPS Mode', 'Heavy Recoil'],
    },
    {
      id: 15,
      name: 'Southside #15',
      settings: ['FPS Mode', 'Heavy Recoil'],
    },
    {
      id: 16,
      name: 'Southside #16',
      settings: ['FPS Mode', 'Heavy Recoil'],
    },
    {
      id: 17,
      name: 'Southside #17',
      settings: ['Third Person', 'Light Recoil'],
    },
    {
      id: 18,
      name: 'Southside #18',
      settings: ['Third Person', 'Light Recoil'],
    },
    {
      id: 19,
      name: 'Southside #19',
      settings: ['Third Person', 'Light Recoil'],
    },
    {
      id: 20,
      name: 'Southside #20',
      settings: ['Third Person', 'Light Recoil'],
    },
  ]);

  const [playerCount, setPlayerCount] = useState(0);
  const [currentWorldID, setCurrentWorldID] = useState<number | null>(null);

  useNuiEvent<PlayerCountData>('erotic-lobby:sendPlayerCount', (data) => {
    if (data.worldID === currentWorldID) { // Ensure currentWorldID is defined or obtained correctly
      setPlayerCount(data.count);
    }
  });

  const handleJoinLobby = (lobbyId: number) => {
    fetchNui('switchWorld', { worldId: lobbyId })
      .then((response) => {
        if (response.success) {
          console.log('Joined lobby successfully!');
          console.log(`Number of people in lobby: ${playerCount}`);
        } else {
          console.error('Failed to join the lobby:', response.error);
        }
      })
      .catch((error) => {
        console.error('Failed to join the lobby:', error);
      });
  };

  type FilterSettings = { [key: string]: boolean; };
  const [filterSettings, setFilterSettings] = useState<FilterSettings>({ 'FPS Mode': false, 'Deluxo': false, 'FFA': false, 'Third Person': false, 'Headshots': false });
  const [selectedRecoil, setSelectedRecoil] = useState('');

  const handleFilterChange = (setting: string) => {
    setFilterSettings({ ...filterSettings, [setting]: !filterSettings[setting] });
  };

  const handleRecoilChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setSelectedRecoil(e.target.value);
  };

  const filteredLobbies = lobbies.filter(lobby =>
    Object.keys(filterSettings).every(setting => 
      !filterSettings[setting] || lobby.settings.includes(setting)
    ) && (!selectedRecoil || lobby.settings.includes(selectedRecoil))
  );

  const [filterHeight, setFilterHeight] = useState(0);
const filterRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (filterRef.current) {
      setFilterHeight(filterRef.current.clientHeight);
    }
  }, [/* dependencies, e.g., state of checkboxes */]);

  return (
    <div className='overlay'>
      <div className="lobby-container">
        <div className="options">
        {Object.keys(filterSettings).map(setting => (
          <label key={setting}>
            <input className='lobby-checkbox'
              type="checkbox"
              checked={filterSettings[setting]}
              onChange={() => handleFilterChange(setting)}
            />
            {setting}
          </label>
        ))}
        <select value={selectedRecoil} onChange={handleRecoilChange} className='lobby-select'> 
          <option value="">All Recoils</option>
          <option value="Light Recoil">Light Recoil</option>
          <option value="Medium Recoil">Medium Recoil</option>
          <option value="High Recoil">High Recoil</option>
        </select>
        </div>
        <div className="lobby-list">
          {filteredLobbies.map((lobby) => (
            <div key={lobby.id} className="lobby-item" onClick={() => handleJoinLobby(lobby.id)}>
              <h3 className="lobby-title">{lobby.name}</h3>
              <div className="lobby-settings">
                {lobby.settings.map((setting, index) => (
                  <p key={index} className="lobby-setting">{setting}</p>
                ))}
              </div>
              <p className="lobby-player-count">Players: {playerCount}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default App;
