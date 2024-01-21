import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { fetchNui } from '../utils/fetchNui';

interface Lobby {
  id: number;
  name: string;
  settings: string[]; // Array of strings for lobby settings
  playerCount: number;
}
const App: React.FC = () => {
  const lobbiesRef = useRef<Lobby[]>([
  // const [lobbies] = useState<Lobby[]>([
    {
      id: 1,
      name: 'Southside #1',
      settings: ['FPS Mode', 'Light Recoil'],
      playerCount: 0
    },
    
    {
      id: 2,
      name: 'FFA',
      settings: ['FPS Mode', 'Light Recoil'],
      playerCount: 0

    },
    {
      id: 3,
      name: 'Southside #3',
      settings: ['FPS Mode', 'Light Recoil', 'Headshots'],
      playerCount: 0
    },
    {
      id: 4,
      name: 'Southside #4',
      settings: ['FPS Mode', 'Light Recoil', 'Headshots'],
      playerCount: 0
    },
    {
      id: 5,
      name: 'Southside #5',
      settings: ['FPS Mode', 'Medium Recoil'],
      playerCount: 0
    },
    {
      id: 6,
      name: 'Southside #6',
      settings: ['FPS Mode', 'Medium Recoil'],
      playerCount: 0
    },
    {
      id: 7,
      name: 'Southside #7',
      settings: ['FPS Mode', 'Medium Recoil', 'Headshots'],
      playerCount: 0
    },
    {
      id: 8,
      name: 'Southside #8',
      settings: ['FPS Mode', 'Medium Recoil', 'Headshots'],
      playerCount: 0
    },
    {
      id: 9,
      name: 'Southside #9',
      settings: ['FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'],
      playerCount: 0
    },
    {
      id: 10,
      name: 'Southside #10',
      settings: ['FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'],
      playerCount: 0
    },
    {
      id: 11,
      name: 'Southside #11',
      settings: ['FPS Mode', 'Medium Recoil'],
      playerCount: 0
    },
    {
      id: 12,
      name: 'Southside #12',
      settings: ['FPS Mode', 'Medium Recoil'],
      playerCount: 0
    },
    {
      id: 13,
      name: 'Southside #13',
      settings: ['FPS Mode', 'Heavy Recoil'],
      playerCount: 0
    },
    {
      id: 14,
      name: 'Southside #14',
      settings: ['FPS Mode', 'Heavy Recoil'],
      playerCount: 0
    },
    {
      id: 15,
      name: 'Southside #15',
      settings: ['FPS Mode', 'Heavy Recoil'],
      playerCount: 0
    },
    {
      id: 16,
      name: 'Southside #16',
      settings: ['FPS Mode', 'Heavy Recoil'],
      playerCount: 0
    },
    {
      id: 17,
      name: 'Southside #17',
      settings: ['Third Person', 'Light Recoil'],
      playerCount: 0
    },
    {
      id: 18,
      name: 'Southside #18',
      settings: ['Third Person', 'Light Recoil'],
      playerCount: 0
    },
    {
      id: 19,
      name: 'Southside #19',
      settings: ['Third Person', 'Light Recoil'],
      playerCount: 0
    },
    {
      id: 20,
      name: 'Southside #20',
      settings: ['Third Person', 'Light Recoil'],
      playerCount: 0
    },
  ]);
  
  const handleJoinLobby = (lobbyId: number) => {
    fetchNui('switchWorld', { worldId: lobbyId })
      .then((response) => {
        if (response.success) {
          console.log('Joined lobby successfully!');
        } else {
          console.error('Failed to join the lobby:', response.error);
        }
      })
      .catch((error) => {
        console.error('Failed to   join the lobby:', error);
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

  const [filteredLobbies, setFilteredLobbies] = useState<Lobby[]>([]);

  useEffect(() => {
    setFilteredLobbies(
      lobbiesRef.current.filter((lobby) =>
        Object.keys(filterSettings).every(
          (setting) =>
            !filterSettings[setting] || lobby.settings.includes(setting)
        ) && (!selectedRecoil || lobby.settings.includes(selectedRecoil))
      )
    );
  }, [filterSettings, selectedRecoil]);

  useEffect(() => {
    const handlePlayerCountUpdate = (event: MessageEvent) => {
      if (event.data.type === 'updatePlayerCount') {
        const newPlayerCount = event.data.count;
        const worldID = event.data.worldId;

        lobbiesRef.current = lobbiesRef.current.map((lobby) => {
          if (lobby.id === worldID) {
            return { ...lobby, playerCount: newPlayerCount };
          }
          return lobby;
        });

        // Update filteredLobbies
        setFilteredLobbies((prevFilteredLobbies) =>
          prevFilteredLobbies.map((lobby) => {
            if (lobby.id === worldID) {
              return { ...lobby, playerCount: newPlayerCount };
            }
            return lobby;
          })
        );
      }
    };

    window.addEventListener('message', handlePlayerCountUpdate);

    return () => {
      window.removeEventListener('message', handlePlayerCountUpdate);
    };
  }, [filterSettings, selectedRecoil]);

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
              <p className="lobby-player-count">Players: {lobby.playerCount}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default App;
