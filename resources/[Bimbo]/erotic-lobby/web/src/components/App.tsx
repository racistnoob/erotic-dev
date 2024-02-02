import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { fetchNui } from '../utils/fetchNui';

interface Lobby {
  id: number;
  name: string;
  settings: string[];
  playerCount: number;
  maxPlayers: number;
}

const App: React.FC = () => {
  const lobbiesRef = useRef<Lobby[]>([

  ]);

  const handleUpdateLobbies = (event: MessageEvent) => {
    if (event.data.type === 'updateLobbies') {
        const receivedLobbies: Lobby[] = event.data.lobbies;

        // Preserve existing player counts
        const updatedLobbies = receivedLobbies.map((receivedLobby: Lobby) => {
            const existingLobby = lobbiesRef.current.find(lobby => lobby.id === receivedLobby.id);

            if (existingLobby) {
                // Lobby already exists, update only properties that need to be changed
                return { ...existingLobby, name: receivedLobby.name, settings: receivedLobby.settings, maxPlayers: receivedLobby.maxPlayers};
            } else {
                // Lobby doesn't exist, add it to the array
                return receivedLobby;
            }
        });

        lobbiesRef.current = updatedLobbies;

        // Update filteredLobbies to display all lobbies
        setFilteredLobbies(updatedLobbies);
    }
};
  
  const handlePlayerCountUpdate = (event: MessageEvent) => {
    //console.log('Received Player Count Update:', event.data);

    if (event.data.type === 'updatePlayerCount') {
        const newPlayerCount = event.data.count;
        const worldID = event.data.worldId;

        lobbiesRef.current = lobbiesRef.current.map((lobby) => {
            if (lobby.id === worldID) {
                return { ...lobby, playerCount: newPlayerCount };
            }
            return lobby;
        });

        setFilteredLobbies((prevFilteredLobbies) =>
            prevFilteredLobbies.map((lobby) => {
                if (lobby.id === worldID) {
                    return { ...lobby, playerCount: newPlayerCount };
                }
                return lobby;
            })
        );

        // Log lobby data before sending to NUI
        //console.log('Updated Lobby Data:', lobbiesRef.current);
    }
  };

  const handleJoinLobby = (lobbyId: number) => {
    fetchNui('switchWorld', { worldId: lobbyId })
      .then((response) => {
        if (response.success) {
          // console.log('Joined lobby successfully!');
        } else {
          console.error('Failed to join the lobby:', response.error);
        }
      })
      .catch((error) => {
        console.error('Failed to join the lobby:', error);
      });
  };

  type FilterSettings = { [key: string]: boolean };
  const [filterSettings, setFilterSettings] = useState<FilterSettings>({
    'FPS Mode': false,
    'Deluxo': false,
    'FFA': false,
    'Third Person': false,
    'Headshots': false,
  });
  const [selectedRecoil, setSelectedRecoil] = useState('');

  const handleFilterChange = (setting: string) => {
    setFilterSettings({ ...filterSettings, [setting]: !filterSettings[setting] });
  };

  const handleRecoilChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setSelectedRecoil(e.target.value);
  };

  const [filteredLobbies, setFilteredLobbies] = useState<Lobby[]>([]);

  useEffect(() => {
    window.addEventListener('message', handleUpdateLobbies);

    // Cleanup function
    return () => {
      window.removeEventListener('message', handleUpdateLobbies);
    };
  }, []); // Make sure to have an empty dependency array to run the effect only once on mount

  useEffect(() => {
    window.addEventListener('message', handlePlayerCountUpdate);
  
    // Cleanup function
    return () => {
      window.removeEventListener('message', handlePlayerCountUpdate);
    };
  }, []); // Make sure to have an empty dependency array to run the effect only once on mount  

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
          <option value="Envy Recoil">Envy Recoil</option>
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
              <p className="lobby-player-count">🧑‍🤝‍🧑:&nbsp;&nbsp;{lobby.playerCount || 0} / {lobby.maxPlayers || 20}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default App;
