//----------------------------------------------------------------------
//	Copyright (C) 2010 Matias N. Goldberg ("dark_sylinc")
//  This file is part of Ogre Meshy.
//
//  Ogre Meshy is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Ogre Meshy is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Ogre Meshy.  If not, see <http://www.gnu.org/licenses/>.
//----------------------------------------------------------------------

#ifndef __MeshyMainFrameImpl__
#define __MeshyMainFrameImpl__

#include "OgrePrerequisites.h"
#include "OgreFrameListener.h"
#include "OgreLog.h"

class wxOgreRenderWindow;
class wxAuiManager;
class wxAuiNotebook;
class wxAuiManagerEvent;
class AnimationPanel;
class AnimPosePanel;
class LightsPanel;

/**
@file
Subclass of MainFrame, which is generated by wxFormBuilder.
*/

#include "wxOgreMeshViewerMainFrame.h"
#include "wxOgreRenderWindowListener.h"

#include "CmdSettings.h"

/** Implementing MainFrame */
class MeshyMainFrameImpl : public MainFrame, public wxOgreRenderWindowListener,
										public Ogre::FrameListener, public Ogre::LogListener
{
	wxAuiManager		*m_wxAuiManager;
	wxTextCtrl			*m_ogreLog;

	Ogre::Root			*m_root;
	Ogre::SceneManager	*m_sceneManager;
	Ogre::Camera		*m_camera;
	Ogre::SceneNode		*m_cameraNode;

	wxOgreRenderWindow	*m_wxOgreRenderWindow;
	wxAuiNotebook		*m_mainNotebook;
	wxTreeCtrl			*m_meshInfoPage;
	AnimationPanel		*m_animationPanel;
	AnimPosePanel		*m_animPosePanel;
	LightsPanel			*m_lightsPanel;
	int					m_lightPanelPageIdx;

	//Directory where we have write access to write our settings
	std::string			m_configDirectory;
	wxString			m_lastOpenResCfgDir;	//OpenFile dialog
	std::string			m_lastOpenMeshDir;		//OpenFile dialog

	std::string			m_meshDir;
	std::string			m_meshName;
	Ogre::Entity		*m_meshEntity;
	Ogre::SceneNode		*m_meshSceneNode;

	std::string			m_resourcesCfgFile; //For custom CFGs

	//For showing axis
	Ogre::SceneNode		*m_axisNode;

	//For the grid
	Ogre::SceneNode		*m_gridNode;
	float				m_cellSize;
	float				m_cellWidth;
	float				m_cellDepth;

	//Control camera movement through mouse
	bool				m_wasLeftPressed;
	bool				m_wasRightPressed;
	int					m_mouseX; //wxWidgets doesn't send us delta, so we have to save last
	int					m_mouseY; //event's data and calculate delta ourselves

	void saveSettings();
	void loadSettings();

	void initOgre( bool bForceSetup );
	void createSystems();
	void createLogWindow( bool bShow );
	void changeBackgroundColour();
	void changeBoneNameColour();
	void showAboutBox();

	void openMeshDialog();
	void openMesh( const std::string &fullPath );
	void openMesh( const std::string &path, const std::string &meshName, bool bResetCamera=false );

	void loadResourcesCfgDialog();
	void loadResourcesCfg( const wxString &file );
	void unloadResourcesCfg();

	void showMeshInfo();
	void showAxis();
	void hideAxis();
	void toggleShowBones();
	void toggleShowBoneNames();
	void createGrid();
	void showGrid();
	void hideGrid();
	void viewGridSettings();

	void defaultCamera();
	void originCamera();
	void centerMeshCamera();
	void rotateCamera( int x, int y );
	void zoomInCamera( Ogre::Real wheelDelta );
	void moveCamera( int x, int y );
	void slideCamera( int x, int z );
	wxString formatBytes( unsigned long bytes ) const;

	void takeSnapshot( bool askLocation );

public:
	/** Constructor */
	MeshyMainFrameImpl( wxWindow* parent, const CmdSettings &cmdSettings );
	~MeshyMainFrameImpl();

	bool frameStarted( const Ogre::FrameEvent& evt );
	void OnMenuSelected( wxCommandEvent& event );

	void OnMouseEvents( wxMouseEvent &evt );

	void messageLogged( const Ogre::String& message, Ogre::LogMessageLevel lml,
						bool maskDebug, const Ogre::String &logName, bool& skipThisMessage );

	void auiEventClose( wxAuiManagerEvent& event );
};

#endif // __MeshyMainFrameImpl__