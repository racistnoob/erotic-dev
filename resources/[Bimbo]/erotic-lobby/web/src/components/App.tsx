import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { fetchNui } from '../utils/fetchNui';

interface Lobby {
  ID: number;
  custom?: boolean;
  playerCount: number;
  settings: {
    name: string;
    recoilMode: string;
    tags?: string[];
    firstPersonVehicle: boolean;
    hsMulti: boolean;
    spawningcars?: boolean;
    RandomSpawns?: { x: number; y: number; z: number; h: number }[];
    maxPlayers: number;
    passwordProtected: boolean;
    password?: string;
  }
}

const App: React.FC = () => {
  const [lobbies, setLobbies] = useState<Lobby[]>([]);
  const [passwordInput, setPasswordInput] = useState('');
  const [showPasswordPrompt, setShowPasswordPrompt] = useState(false);
  const [selectedLobby, setSelectedLobby] = useState<Lobby | null>(null);
  const [tab, setTab] = useState<'Normal' | 'Custom'>('Normal');
  const [showCustomLobbyPrompt, setShowCustomLobbyPrompt] = useState(false);
  const [customLobbySettings, setCustomLobbySettings] = useState<{
    name: string;
    maxPlayers: number;
    recoilMode: string;
    firstPersonVehicle: boolean;
    hsMulti: boolean;
    passwordProtected: boolean;
    password?: string;
  }>({
    maxPlayers: 12,
    name: '',
    recoilMode: 'roleplay',
    firstPersonVehicle: false,
    hsMulti: false,
    passwordProtected: true,
    password: ''
  });

  const handleUpdateLobbies = (event: MessageEvent) => {
    if (event.data.type === 'updateLobbies') {
      const receivedLobbies: Lobby[] = event.data.lobbies;

      setLobbies(prevLobbies => {
        const updatedLobbies = receivedLobbies.map((receivedLobby: Lobby) => {
          const existingLobbyIndex = prevLobbies.findIndex(lobby => lobby.ID === receivedLobby.ID);
    
          if (existingLobbyIndex !== -1) {
            return {
              ...prevLobbies[existingLobbyIndex],
              custom: receivedLobby.custom,
              name: receivedLobby.settings.name,
              settings: receivedLobby.settings,
            };
          } else {
            return {
              ...receivedLobby,
              custom: receivedLobby.custom,
            };
          }
        });
        return updatedLobbies;
      });
    }
  };  

  const handlePlayerCountUpdate = (event: MessageEvent) => {
    if (event.data.type === 'updatePlayerCount') {
      const newPlayerCount = event.data.count;
      const worldID = event.data.worldId;
  
      setLobbies(prevLobbies => {
        return prevLobbies.map((lobby) => {
          if (lobby.ID === worldID) {
            return { ...lobby, playerCount: newPlayerCount };
          }
          return lobby;
        });
      });
    }
  };
  
  const handleJoinLobby = (lobbyId: number) => {
    const lobby = lobbies.find(lobby => lobby.ID === lobbyId);
    if (lobby && lobby.settings.passwordProtected) {
      setSelectedLobby(lobby);
      setShowPasswordPrompt(true);
    } else {
      joinLobby(lobbyId, '');
    }
  };  

  const joinLobby = (lobbyId: number, password: string) => {
    fetchNui('switchWorld', { worldId: lobbyId, password })
      .then((response) => {
        if (!response.success) {
          console.error('Failed to join the lobby:', response.error);
        }
      })
      .catch((error) => {
        console.error('Failed to join the lobby:', error);
      });
  };

  const handlePasswordInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setPasswordInput(e.target.value);
  };

  const handlePasswordSubmit = () => {
    if (selectedLobby) {
      if (passwordInput.trim() === selectedLobby.settings.password) {
        joinLobby(selectedLobby.ID, passwordInput);
        setShowPasswordPrompt(false);
        setPasswordInput('');
        setSelectedLobby(null);
      } else {
        setShowPasswordPrompt(false);
        setPasswordInput('');
        setSelectedLobby(null);
      }
    }
  };  

  const handleCancel = () => {
    setShowPasswordPrompt(false);
    setPasswordInput('');
    setSelectedLobby(null);
  };

window.addEventListener('message', (event) => {
  if (event.data.type === 'createCustomLobby') {
      const customLobbySettings = event.data.customLobbySettings;
      console.log('Received custom lobby settings:', customLobbySettings);
  }
});

const handleCreateCustomLobby = () => {
  fetchNui('createCustomLobby', customLobbySettings)
      .then(response => {
          if (response.success) {
              console.log('Custom lobby created successfully!');

          } else {
              console.error('Failed to create custom lobby:', response.error);

          }
      })
      .catch(error => {
          console.error('Error creating custom lobby:', error);

      });
  setShowCustomLobbyPrompt(false);
};

  useEffect(() => {
    window.addEventListener('message', handleUpdateLobbies);
    return () => {
      window.removeEventListener('message', handleUpdateLobbies);
    };
  }, []);

  useEffect(() => {
    window.addEventListener('message', handlePlayerCountUpdate);
    return () => {
      window.removeEventListener('message', handlePlayerCountUpdate);
    };
  }, []);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.type === 'closeCustomLobbyPrompt') {
        setShowCustomLobbyPrompt(false);
      }
    };

    window.addEventListener('message', handleMessage);

    return () => {
      window.removeEventListener('message', handleMessage);
    };
  }, []);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.type === 'closePasswordPrompt') {
        setShowPasswordPrompt(false);
        setPasswordInput('');
        setSelectedLobby(null);
      }
    };

    window.addEventListener('message', handleMessage);

    return () => {
      window.removeEventListener('message', handleMessage);
    };
  }, []);

  const lobbys = tab === 'Normal' ? lobbies.filter(lobby => !lobby.custom) : lobbies.filter(lobby => lobby.custom);

  return (
    <div className='overlay'>
      <div className="lobby-container">
        <div className="tab-container">
          <button className={tab === 'Normal' ? 'active-tab' : ''} onClick={() => setTab('Normal')}>Normal</button>
          <button className={tab === 'Custom' ? 'active-tab' : ''} onClick={() => setTab('Custom')}>Custom</button>
        </div>
        <div className="custom-lobby">
          {tab === 'Custom' && <button className='custom-lobby-button' onClick={() => setShowCustomLobbyPrompt(true)}>Create lobby</button>}
        </div>
        <div className="lobby-list">
          {lobbys.map((lobby) => (
            <div key={lobby.ID} className="lobby-item" onClick={() => handleJoinLobby(lobby.ID)}>
              <h3 className="lobby-title">{lobby.settings.name}</h3>
              <div className="lobby-settings">
                {lobby.settings.tags?.map((tag, index) => (
                  <p key={index} className="lobby-setting">{tag}</p>
                ))}
              </div>
              <p className="lobby-player-count">
                {lobby.settings.passwordProtected && <span>🔒</span>}
                🧑‍🤝‍🧑:&nbsp;&nbsp;{lobby.playerCount || 0} / {lobby.settings.maxPlayers || 20}
              </p>
            </div>
          ))}
        </div>
      </div>
      {showPasswordPrompt && (
        <div className="modal-background">
          <div className="password-prompt">
              <div className="password-input-container">
                  <input
                      type="password"
                      value={passwordInput}
                      onChange={handlePasswordInputChange}
                      placeholder="Enter password"
                      maxLength={6}
                      className="password-input"
                  />
              </div>
              <div className="button-container">
                  <button onClick={handleCancel}>Cancel</button>
                  <button onClick={handlePasswordSubmit}>Submit</button>
              </div>
          </div>
        </div>
      )}
      {/* Render custom lobby prompt when showCustomLobbyPrompt is true */}
      {showCustomLobbyPrompt && (
        <div className="modal-background">
          <div className="custom-lobby-prompt">
            <h2>Create Custom Lobby</h2>
            <div className="toggle-switch">
                <label>First Person Vehicle:</label>
                <label className="switch">
                    <input type="checkbox" checked={customLobbySettings.firstPersonVehicle} onChange={(e) => setCustomLobbySettings({ ...customLobbySettings, firstPersonVehicle: e.target.checked })} />
                    <span className="slider round"></span>
                </label>
            </div>
            <div className="toggle-switch">
                <label>Headshots:</label>
                <label className="switch">
                    <input type="checkbox" checked={customLobbySettings.hsMulti} onChange={(e) => setCustomLobbySettings({ ...customLobbySettings, hsMulti: e.target.checked })} />
                    <span className="slider round"></span>
                </label>
            </div>
            <label>Recoil Mode:</label>
            <select value={customLobbySettings.recoilMode} onChange={(e) => setCustomLobbySettings({ ...customLobbySettings, recoilMode: e.target.value })}>
              <option value="roleplay">Default</option>
              <option value="envy">Envy</option>
              <option value="hardcore">Hardcore</option>
              <option value="roleplay3">Third Person Recoil</option>
              <option value="roleplay2">roleplay2</option>
              <option value="qb">qb</option>
            </select>
            <div className="password-input-container">
              <input
                  type="password"
                  value={customLobbySettings.password}
                  onChange={(e) => setCustomLobbySettings({ ...customLobbySettings, password: e.target.value })}
                  placeholder="Enter password"
                  className="password-input"
                  maxLength={6}
              />
              <p className='password-icon'>🔒</p>
          </div>
            <div className="button-container">
              <button onClick={() => setShowCustomLobbyPrompt(false)}>Cancel</button>
              <button onClick={() => handleCreateCustomLobby()}>Create Lobby</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );  
};

export default App;