/**
 * vim: set ts=4 :
 * =============================================================================
 * Randomize Teams
 * Randomize team slots for Fistful of Frags.  This allows for 2-Team Shootouts
 * that are not allways Vigilantes vs Desperados.
 *
 * Copyright 2015 Crimsontautology
 * =============================================================================
 *
 */

#pragma semicolon 1

#include <sourcemod>

#define PLUGIN_VERSION "1.0.0"
#define PLUGIN_NAME "[FoF] Randomize Teams"

public Plugin:myinfo =
{
    name = PLUGIN_NAME,
    author = "CrimsonTautology",
    description = "Randomize the team names for Fistful of Frags",
    version = PLUGIN_VERSION,
    url = "https://github.com/CrimsonTautology/sm_randomize_teams"
};

public OnPluginStart()
{
    CreateConVar("sm_randomize_teams_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD);
    RegAdminCmd("sm_randomize_teams", Command_RandomizeTeams, ADMFLAG_SLAY, "Randomize the team slots");
}

public Action:Command_RandomizeTeams(client, args)
{
    RandomizeTeams();
    return Plugin_Handled;
}

RandomizeTeams()
{
}

//fof_sv_team_remap_[1-4] : reassign a team to team slot 1: 2-vigilantes, 3-desperados, 4-bandidos, 5-rangers
TeamRemap(team, team_slot)
{
    assert(team >= 1 && team <= 4);
    assert(team_slot >= 2 && team_slot <= 5);

    ServerCommand("fof_sv_team_remap_%d \"%d\"", team, team_slot);
}

