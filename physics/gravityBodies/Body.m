classdef Body < handle

    properties
        Mass
        Radius
        Position
        Velocity
        VelocityHalfStep
        PositionRecord
        VelocityRecord
        VelocityHalfRecord
        Color
    end

    methods

        function body = Body(m, r, p, v, color)
            % Constructor
            body.Mass = m;
            body.Radius = r;
            body.Position = p;
            body.Velocity = v;
            body.PositionRecord = [p];
            body.VelocityRecord = [v];
            body.VelocityHalfRecord = [v];
            body.Color = color;
        end

        function dirVec = DirToOther(obj, other)
            dirVec = obj.Position.UnitDirVecOther(other.Position);
        end

        function a_vec = Acc(obj, other, G)
            r = obj.Position.DirVecOther(other.Position).Magnitude;
            a = -G * other.Mass / r^2;
            a_vec = other.DirToOther(obj).Scale(a);
        end

        function has_collided = DetectCollision(obj, other)
            d = obj.Position.DirVecOther(other.Position).Magnitude;
            min_d = obj.Radius + other.Radius;
            has_collided = d <= min_d;
        end

        function sum = NetAcc(obj, others, G)
            sum = Vec(0, 0, 0);

            for i = 1:length(others)
                a = obj.Acc(others(i), G);
                sum = sum.Add(a);
            end

        end

        function f = NetForce(obj, others, G)
            sum = obj.NetAcc(others, G).Scale(obj.Mass);
            f = sum.Scale(obj.Mass);
        end

        function VHalfStep(obj, acc, dt)
            diff = acc.Scale(0.5 * dt);
            obj.VelocityHalfStep = obj.Velocity.Add(diff);
            obj.VelocityHalfRecord = [obj.VelocityHalfRecord obj.VelocityHalfStep];
        end

        function PosStep(obj, dt)
            diff = obj.VelocityHalfStep.Scale(dt);
            obj.Position = obj.Position.Add(diff);
            obj.PositionRecord = [obj.PositionRecord obj.Position];
        end

        function VFullStep(obj, acc, dt)
            diff = acc.Scale(0.5 * dt);
            obj.Velocity = obj.Velocity.Add(diff);
            obj.VelocityRecord = [obj.VelocityRecord obj.Velocity];
        end

    end

end
