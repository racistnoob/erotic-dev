import React, { useEffect, useRef, useState } from 'react';
import './App.css';
import { fetchNui } from '../utils/fetchNui';

interface Lobby {
  ID: number;
  settings: {
    name: string;
    recoilMode: string;
    tags: string[];
    firstPersonVehicle: boolean;
    hsMulti: boolean;
    spawningcars?: boolean;
    RandomSpawns?: { x: number; y: number; z: number; h: number }[];
  };
  playerCount: number;
}

const App: React.FC = () => {
    const lobbiesRef = useRef<Lobby[]>([]);
  
    const handleUpdateLobbies = (event: MessageEvent) => {
      if (event.data.type === 'updateLobbies') {
        const receivedLobbies: Lobby[] = event.data.lobbies;
  
        const updatedLobbies = receivedLobbies.map((receivedLobby: Lobby) => {
          const existingLobby = lobbiesRef.current.find(lobby => lobby.ID === receivedLobby.ID);
  
          if (existingLobby) {
            return {
              ...existingLobby,
              name: receivedLobby.settings.name,
              settings: receivedLobby.settings,
            };
          } else {
            return receivedLobby;
          }
        });
  
        lobbiesRef.current = updatedLobbies;
  
        setFilteredLobbies(updatedLobbies);
      }
    };
  
  const handlePlayerCountUpdate = (event: MessageEvent) => {
    console.log('Received Player Count Update:', event.data);

    if (event.data.type === 'updatePlayerCount') {
        const newPlayerCount = event.data.count;
        const worldID = event.data.worldId;

        lobbiesRef.current = lobbiesRef.current.map((lobby) => {
            if (lobby.ID === worldID) {
                return { ...lobby, playerCount: newPlayerCount };
            }
            return lobby;
        });

        setFilteredLobbies((prevFilteredLobbies) =>
            prevFilteredLobbies.map((lobby) => {
                if (lobby.ID === worldID) {
                    return { ...lobby, playerCount: newPlayerCount };
                }
                return lobby;
            })
        );

        console.log('Updated Lobby Data:', lobbiesRef.current);
    }
  };

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
        console.error('Failed to join the lobby:', error);
      });
  };

  const [filteredLobbies, setFilteredLobbies] = useState<Lobby[]>([]);

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

  return (
    <div className='overlay'>
      <div className="lobby-container">
        {/* ... (other code) */}
        <div className="lobby-list">
          {filteredLobbies.map((lobby) => (
            <div key={lobby.ID} className="lobby-item" onClick={() => handleJoinLobby(lobby.ID)}>
              <h3 className="lobby-title">{lobby.settings.name}</h3>
              <div className="lobby-settings">
                {lobby.settings.tags.map((tag, index) => (
                  <p key={index} className="lobby-setting">{tag}</p>
                ))}
              </div>
              <p className="lobby-player-count">🧑‍🤝‍🧑/ {lobby.playerCount || 0}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default App;
