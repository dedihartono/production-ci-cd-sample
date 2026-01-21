// Sample portfolio data
const portfolioData = {
  name: 'John Doe',
  title: 'Full Stack Developer',
  bio: 'Passionate developer with expertise in modern web technologies',
  skills: ['JavaScript', 'Node.js', 'React', 'Docker', 'CI/CD'],
  projects: [
    {
      id: 1,
      title: 'E-Commerce Platform',
      description: 'Full-stack e-commerce solution with payment integration',
      technologies: ['React', 'Node.js', 'PostgreSQL'],
      link: 'https://example.com/project1',
    },
    {
      id: 2,
      title: 'Task Management App',
      description: 'Collaborative task management with real-time updates',
      technologies: ['React', 'Express', 'MongoDB', 'Socket.io'],
      link: 'https://example.com/project2',
    },
    {
      id: 3,
      title: 'CI/CD Pipeline',
      description: 'Production-ready CI/CD setup with automated testing',
      technologies: ['Docker', 'GitHub Actions', 'GitLab CI'],
      link: 'https://example.com/project3',
    },
  ],
};

const portfolioController = {
  getPortfolio: (req, res) => {
    res.json({
      success: true,
      data: {
        name: portfolioData.name,
        title: portfolioData.title,
        bio: portfolioData.bio,
        skills: portfolioData.skills,
      },
    });
  },

  getProjects: (req, res) => {
    res.json({
      success: true,
      data: portfolioData.projects,
    });
  },

  getProjectById: (req, res) => {
    const { id } = req.params;
    const project = portfolioData.projects.find((p) => p.id === parseInt(id, 10));

    if (!project) {
      return res.status(404).json({
        success: false,
        error: 'Project not found',
      });
    }

    res.json({
      success: true,
      data: project,
    });
  },
};

module.exports = portfolioController;
