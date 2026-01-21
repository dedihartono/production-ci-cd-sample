import { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

// API_URL should be base URL (e.g., http://localhost or http://localhost:3000)
// The /api prefix will be added in the fetch calls
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';

function App() {
  const [portfolio, setPortfolio] = useState(null);
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchPortfolio();
    fetchProjects();
  }, []);

  const fetchPortfolio = async () => {
    try {
      // Remove /api from API_URL if present, then add it back to avoid duplication
      const baseUrl = API_URL.replace(/\/api\/?$/, '');
      const response = await axios.get(`${baseUrl}/api/portfolio`);
      setPortfolio(response.data.data);
    } catch (err) {
      setError('Failed to load portfolio data');
      console.error('Error fetching portfolio:', err);
    } finally {
      setLoading(false);
    }
  };

  const fetchProjects = async () => {
    try {
      // Remove /api from API_URL if present, then add it back to avoid duplication
      const baseUrl = API_URL.replace(/\/api\/?$/, '');
      const response = await axios.get(`${baseUrl}/api/portfolio/projects`);
      setProjects(response.data.data);
    } catch (err) {
      console.error('Error fetching projects:', err);
    }
  };

  if (loading) {
    return (
      <div className="App">
        <div className="container">
          <div className="loading">Loading...</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="App">
        <div className="container">
          <div className="error">{error}</div>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      <header className="App-header">
        <div className="container">
          {portfolio && (
            <>
              <h1>{portfolio.name}</h1>
              <h2>{portfolio.title}</h2>
              <p className="bio">{portfolio.bio}</p>
              <div className="skills">
                <h3>Skills</h3>
                <div className="skills-list">
                  {portfolio.skills.map((skill, index) => (
                    <span key={index} className="skill-tag">
                      {skill}
                    </span>
                  ))}
                </div>
              </div>
            </>
          )}
        </div>
      </header>

      <main className="App-main">
        <div className="container">
          <h2>Projects</h2>
          <div className="projects-grid">
            {projects.map((project) => (
              <div key={project.id} className="project-card">
                <h3>{project.title}</h3>
                <p>{project.description}</p>
                <div className="technologies">
                  {project.technologies.map((tech, index) => (
                    <span key={index} className="tech-tag">
                      {tech}
                    </span>
                  ))}
                </div>
                {project.link && (
                  <a
                    href={project.link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="project-link"
                  >
                    View Project
                  </a>
                )}
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;
