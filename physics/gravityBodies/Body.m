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
        KERecord
        PERecord
        LinMRecord
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
            obj.KERecord = [obj.KERecord KineticEnergy(obj)];
            obj.LinMRecord = [obj.LinMRecord LinMomentum(obj)];
        end

        function Ek = KineticEnergy(obj)
            Ek = obj.Mass * (obj.Velocity.Magnitude)^2;
        end

        function Ep = PotentialEnergy(obj, others, G)
            positions = obj.PositionRecord;
            N = length(positions);
            Ep = zeros(1, N);
            m = obj.Mass;

            for i = 1:length(others)
                other = others(i);
                M = other.Mass;

                for j = 1:N
                    p = positions(j);
                    p2 = other.PositionRecord(j);
                    r = p.DirVecOther(p2).Magnitude;
                    PE = (-G * M * m) / r;

                    Ep(j) = Ep(j) + PE;
                end

            end

        end

        function momentum = LinMomentum(obj)
            momentum = obj.Velocity.Scale(obj.Mass);
        end

    end

end
