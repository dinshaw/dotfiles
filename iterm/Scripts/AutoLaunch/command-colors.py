#!/usr/bin/env python3

import iterm2
import re

async def SetPresetInSession(connection, session, preset_name):
    preset = await iterm2.ColorPreset.async_get(connection, preset_name)

    if not preset:
        print("No preset found.")
        return

    profile = await session.async_get_profile()

    if not profile:
        print("No profile found.")
        return

    await profile.async_set_color_preset(preset)

async def main(connection):
    app = await iterm2.async_get_app(connection)
    print(app)

    async def monitor(session_id):
        session = app.get_session_by_id(session_id)
        if not session:
            print("No session found.")
            return

        while True:
            async with iterm2.VariableMonitor(
                connection, iterm2.VariableScopes.SESSION, "commandLine", session_id
                ) as mon:
                command_str = await mon.async_get()
                print("CMD:", command_str)

            if re.search("rails s", command_str):
                print ("match rails s")
                await SetPresetInSession(connection, session, 'Solarized Light')
            elif re.search("rails c", command_str):
                print ("match rails c")
                await SetPresetInSession(connection, session, 'Borland')
            elif re.search("-bash", command_str):
                print ("match bash")
                await SetPresetInSession(connection, session, 'Arthur')

iterm2.run_forever(main)
